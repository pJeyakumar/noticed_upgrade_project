class LogbookEntryMailer < ApplicationMailer
  has_history
  track_clicks campaign: "log_book_entry_emails_campaign"

  before_action :set_user
  before_action :set_logbook_entry

  def created_email
    mail(to: @user.email, subject: I18n.t("mailer.logbook_entry.created.subject", pilot: @logbook_entry.pilot_in_command))
  end

  def updated_email
    mail(to: @user.email, subject: I18n.t("mailer.logbook_entry.updated.subject", pilot: @logbook_entry.pilot_in_command))
  end

  private

  def set_user
    @user = params[:recipient]
  end

  def set_logbook_entry
    @logbook_entry = params[:logbook_entry]
  end
end
