class NewLogbookEntryCreatedNotifier < Noticed::Event
  deliver_by :database, if: :database_notifications?
  deliver_by :email, mailer: "LogbookEntryMailer", method: "created_email", if: :email_notifications?

  DEFAULT_SEND_NOTIFICATION = true
  DEFAULT_SEND_EMAIL_NOTIFICATION = true

  required_param :logbook_entry

  notification_methods do
    def message
      "#{params[:logbook_entry].pilot_in_command} has created a logbook entry for their flight sim on the #{params[:logbook_entry].aircraft}."
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
  end

  def self.targets
    # TEMP - will adjust so that only a specific set of users will receive the notification
    User.all
  end
end
