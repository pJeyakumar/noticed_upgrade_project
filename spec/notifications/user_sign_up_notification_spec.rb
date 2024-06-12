require "rails_helper"

RSpec.describe(UserSignUpNotification, type: :model) do
  context "when a new user signs up" do
    it "creates database notifications" do
      expect { create(:user) }.to(change(Notification, :count).by(1))
    end

    it "creates email notifications" do
      expect { create(:user) }.to(change { UserMailer.deliveries.count }.by(1))
    end

    it "sends the proper email subject" do
      user = create(:user)
      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to(eq( I18n.t("mailer.user.created.subject", email: user.email)))
    end
  end
end
