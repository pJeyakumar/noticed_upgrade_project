class User < ApplicationRecord
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

  private

  def notify_creation_to_user
    UserSignUpNotification.with(event_user: self).deliver_later(UserSignUpNotification.targets)
  end

  def notify_update_to_user
    UserUpdateNotification.with(event_user: self).deliver_later(UserUpdateNotification.targets)
  end
end
