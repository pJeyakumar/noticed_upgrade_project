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

  has_many :noticed_events, as: :record, dependent: :destroy, class_name: "Noticed::Event"
  has_many :noticed_notifications, as: :event_user, dependent: :destroy, class_name: "Noticed::Notification"
  has_many :noticed_notifications, as: :recipient, dependent: :destroy, class_name: "Noticed::Notification"


  after_create_commit :notify_creation_to_user
  after_update :notify_update_to_user

  def to_s
    "#{first_name} #{last_name}"
  end

  def wing_admin
    context == AircraftPolicy::WING_ADMIN_PERMISSION
  end

  private

  def notify_creation_to_user
    debugger
    UserSignUpNotifier.with(event_user: self).deliver_later(UserSignUpNotifier.targets)
  end

  def notify_update_to_user
    UserUpdateNotifier.with(event_user: self).deliver_later(UserUpdateNotifier.targets)
  end
end
