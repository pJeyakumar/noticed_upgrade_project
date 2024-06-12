require "rails_helper"

RSpec.describe(NewAircraftCreatedNotification, type: :model) do
  # Must eagerly create a user first, or notifications will not be created
  before { create(:user) }

  context "when aircraft are created" do
    it "creates database notifications" do
      expect { create(:aircraft) }.to(change(Notification, :count).by(1))
    end

    it "creates email notifications" do
      expect { create(:aircraft) }.to(change { UserMailer.deliveries.count }.by(1))
    end

    it "sends the proper email subject" do
      create(:aircraft)
      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to(include("New Aircraft Created")) # replace by translated comment
    end
  end
end
