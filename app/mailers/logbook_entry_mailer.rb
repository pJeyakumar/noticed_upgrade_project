class LogbookEntryMailer < ApplicationMailer
    before_action :set_user
    before_action :set_logbook_entry
  
    track_clicks campaign: "logbook_entry_created_email", only: %i[created_email]
  
    has_history extra: -> { {sent: true, messageable: @aircraft} }
  
    def created_email 
      @pilot_in_command = User.find_by(id: @logbook_entry.pilot_in_command_id).first_name
      mail(to: @user.email, subject: "[DIGITAL FLIGHT SIM] New Logbook Entry By: #{@pilot_in_command}")
    end
  
    private
  
    def set_user
      @user = params[:recipient]
    end
  
    def set_logbook_entry
      @logbook_entry = params[:logbook_entry]
    end
end
