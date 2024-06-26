class UserMailer < ApplicationMailer
  has_history
  track_clicks campaign: "users_emails_campaign"

  before_action :set_user
  before_action :set_event_user

  def welcome_email(user)
    @url = "http://example.com/login"
    mail(to: user.email, subject: I18n.t("mailer.user.welcome.subject"))
  end

  def created_user
    mail(to: @user.email, subject: I18n.t("mailer.user.created.subject", email: @event_user.email))
  end

  def update_user
    mail(to: @user.email, subject: I18n.t("mailer.user.updated.subject", event_user: @event_user))
  end

  private

  def set_user
    @user = params[:recipient]
  end

  def set_event_user
    @event_user = params[:event_user]
  end
end
