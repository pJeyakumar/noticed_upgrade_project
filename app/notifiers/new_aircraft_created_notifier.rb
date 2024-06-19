class NewAircraftCreatedNotifier < Noticed::Base
  deliver_by :database, if: :database_notifications?
  deliver_by :email, mailer: "AircraftMailer", method: "created_email", if: :email_notifications?

  # Variables that tells the system if it should send a notification if the recipient isn't subscribed
  DEFAULT_SEND_NOTIFICATION = true
  DEFAULT_SEND_EMAIL_NOTIFICATION = true

  # Add required required_params
  required_param :aircraft

  notification_methods do
    def message
      "#{required_params[:aircraft].name} has been created for use in the flight sim."
    end

    def url
      aircraft_path(required_params[:aircraft])
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
end
