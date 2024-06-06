class User < ApplicationRecord
  has_many :logbook_entries, class_name: "LogbookEntry", foreign_key: "pilot_in_command_id"
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  has_many :notifications, as: :recipient, dependent: :destroy
  has_noticed_notifications
  has_noticed_notifications param_name: :assigned_to, destroy: false, model_name: "Notification"
  has_noticed_notifications param_name: :requester, destroy: false, model_name: "Notification"
  has_noticed_notifications param_name: :granted_by, destroy: false, model_name: "Notification"

  def to_s
    "#{first_name} #{last_name}"
  end
end
