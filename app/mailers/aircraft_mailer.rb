class AircraftMailer < ApplicationMailer
  has_history
  track_clicks campaign: "aircraft-email-campaign"

  before_action :set_user
  before_action :set_aircraft


  def created_email
    mail(to: @user.email, subject: "[DIGITAL FLIGHT SIM] New Aircraft Created: #{@aircraft}")
  end

  private

  def set_user
    @user = params[:recipient]
  end

  def set_aircraft
    @aircraft = params[:aircraft]
  end
end
