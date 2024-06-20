require "rails_helper"

RSpec.describe(NewAircraftCreatedNotification, type: :model) do
  # Must eagerly create a user first, or notifications will not be created
  before { create(:user) }

  let(:aircraft) { create(:aircraft) }

  context "when aircraft are created" do
    it "creates database notifications" do
      expect { aircraft }.to(change(Notification, :count).by(1))
    end

    it "creates email notifications" do
      expect { aircraft }.to(change { UserMailer.deliveries.count }.by(1))
    end

    it "sends the proper email subject" do
      aircraft
      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to(eq(I18n.t("mailer.aircraft.created.subject", aircraft: aircraft)))
    end
  end
end
