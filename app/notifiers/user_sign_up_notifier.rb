class UserSignUpNotifier < Noticed::Event
  deliver_by :email, mailer: "UserMailer", method: "created_user", if: :email_notifications?

  # Variables that tells the system if it should send a notification if the recipient isn't subscribed
  DEFAULT_SEND_NOTIFICATION = true
  DEFAULT_SEND_EMAIL_NOTIFICATION = true

  # Add required params
  required_param :event_user

  notification_methods do
    def message
      "A new user #{params[:event_user]} with email #{params[:event_user].email} has been signed up."
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
  end

  def self.targets
    User.all # TODO: TEMPORARY
  end
end
