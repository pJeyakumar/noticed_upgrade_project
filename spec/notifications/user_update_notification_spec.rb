require "rails_helper"

RSpec.describe(UserUpdateNotification, type: :model) do
  let!(:user) { create(:user) }

  context "when a user is updated" do
    it "creates database notification" do
      expect { user.update(email: "new@email.com") }.to(change(Notification, :count).by(1))
    end

    it "creates email notification" do
      expect { user.update(email: "new@email.com") }.to(change { UserMailer.deliveries.count }.by(1))
    end

    it "sends the proper email subject" do
      user.update(email: "new@email.com")
      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to(include("User Updated")) # replace by translated comment
    end
  end
end
