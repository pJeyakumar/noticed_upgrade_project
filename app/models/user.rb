class User < ApplicationRecord
  # rubocop:disable Naming/VariableNumber
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable,
    :omniauthable,
    omniauth_providers: %i[facebook google_oauth2]
  # rubocop:enable Naming/VariableNumber

  has_many :logbook_entries, class_name: "LogbookEntry", foreign_key: "pilot_in_command_id", dependent: :destroy, inverse_of: :pilot_in_command

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  has_many :notifications, as: :recipient, dependent: :destroy

  has_noticed_notifications
  has_noticed_notifications param_name: :assigned_to, destroy: false, model_name: "Notification"
  has_noticed_notifications param_name: :requester, destroy: false, model_name: "Notification"
  has_noticed_notifications param_name: :granted_by, destroy: false, model_name: "Notification"

  after_create_commit :notify_creation_to_user
  after_update :notify_update_to_user

  def to_s
    "#{first_name} #{last_name}"
  end

  def admin
    (context == AircraftPolicy::AIRCRAFT_PERM_STRING) ? "1" : "0"
  end

  def admin=(value)
    self.context = (value == "1") ? AircraftPolicy::AIRCRAFT_PERM_STRING : ""
  end

  private

  def notify_creation_to_user
    UserSignUpNotification.with(event_user: self).deliver_later(UserSignUpNotification.targets)
  end

  def notify_update_to_user
    UserUpdateNotification.with(event_user: self).deliver_later(UserUpdateNotification.targets)
  end
end
