class NewAircraftCreatedNotification < Noticed::Base

  deliver_by :database, debug: true


  deliver_by :database, if: :database_notifications?
  deliver_by :email, mailer: "AircraftMailer", method: "created_email", if: :email_notifications?

  # Variables that tells the system if it should send a notification if the recipient isn't subscribed
  DEFAULT_SEND_NOTIFICATION = true
  DEFAULT_SEND_EMAIL_NOTIFICATION = true

  # Add required params
  param :aircraft

  def message
    "#{params[:aircraft].name} has been created for use in the flight sim."
  end

  def url
    aircraft_path(params[:aircraft])
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
