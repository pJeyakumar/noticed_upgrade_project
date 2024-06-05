class NewLogbookEntryCreatedNotification < Noticed::Base
  deliver_by :database, if: :database_notifications?
  deliver_by :email, mailer: "LogbookEntryMailer", method: "created_email", if: :email_notifications?

  DEFAULT_SEND_NOTIFICATION = true
  DEFAULT_SEND_EMAIL_NOTIFICATION = true

  param :logbook_entry

  def message
    aircraft_model = Aircraft.find_by(id: params[:logbook_entry].aircraft_id).model
    "A logbook entry for #{params[:logbook_entry].first_name} has been created for #{aircraft_model}."
  end

  def url
    logbook_entry_path(params[:logbook_entry])
  end

  def database_notifications?
    DEFAULT_SEND_NOTIFICATION
  end

  def email_notifications?
    DEFAULT_SEND_EMAIL_NOTIFICATION
  end

  def self.targets
    # TEMP - will adjust so that only a specific set of users will receive the notification
    User.all
  end
end
