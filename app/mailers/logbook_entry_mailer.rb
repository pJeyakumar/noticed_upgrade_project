class LogbookEntryMailer < ApplicationMailer
    has_history
    track_clicks campaign: "log-book-entry-emails-campaign"

    before_action :set_user
    before_action :set_logbook_entry
  
    # track_clicks campaign: "logbook_entry_created_email", only: %i[created_email]
  
    # has_history extra: -> { {sent: true, messageable: @aircraft} }
  
    def created_email 
      mail(to: @user.email, subject: "[DIGITAL FLIGHT SIM] New Logbook Entry By: #{@logbook_entry.pilot_in_command}")
    end

    def updated_email
      mail(to: @user.email, subject: "[DIGITAL FLIGHT SIM] Updated #{@logbook_entry.pilot_in_command}'s Logbook Entry")
    end
  
    private
  
    def set_user
      @user = params[:recipient]
    end
  
    def set_logbook_entry
      @logbook_entry = params[:logbook_entry]
    end
end
