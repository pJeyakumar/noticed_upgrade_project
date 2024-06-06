
class LogbookEntryUpdatedNotification < Noticed::Base
  deliver_by :database, if: :database_notifications?
  deliver_by :email, mailer: "LogbookEntryMailer", method: "updated_email", if: :email_notifications?

  DEFAULT_SEND_NOTIFICATION = true
  DEFAULT_SEND_EMAIL_NOTIFICATION = true

  param :logbook_entry

  def message
    aircraft_model = Aircraft.find_by(id: params[:logbook_entry].aircraft_id).model
    "#{params[:logbook_entry].first_name}'s #{params[:logbook_entry].date} logbook entry has been updated for their flight sim on the #{aircraft_model}."
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
