class UserMailer < ApplicationMailer
  before_action :set_user
  before_action :set_event_user
  
  def welcome_email(user)  
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def created_user
    mail(to: @user.email, subject: "[DIGITAL FLIGHT SIM] New User Created: #{@event_user.email}")
  end

  def update_user    
    mail(to: @user.email, subject: "[DIGITAL FLIGHT SIM] New Aircraft Created: #{@event_user}")
  end

  private

  def set_user
    @user = params[:user]
  end

  def set_event_user
    @event_user = params[:event_user]
  end  
end
