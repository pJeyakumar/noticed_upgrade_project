class UserUpdateNotification < Noticed::Base
  deliver_by :database, if: :database_notifications?
  deliver_by :email, mailer: "UserMailer", method: "update_user", if: :email_notifications?

  # Variables that tells the system if it should send a notification if the recipient isn't subscribed
  DEFAULT_SEND_NOTIFICATION = true
  DEFAULT_SEND_EMAIL_NOTIFICATION = true

  # Add required params
  param :event_user

  def message
    "The user #{params[:event_user]} - #{params[:event_user].email} has been updated."
  end

  def url
    user_path(params[:event_user])
  end

  def database_notifications?
    DEFAULT_SEND_NOTIFICATION
  end

  def email_notifications?
    DEFAULT_SEND_EMAIL_NOTIFICATION
  end

  def self.targets
    User.all # TODO: TEMPORARY
  end
end
