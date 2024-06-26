require "rails_helper"

RSpec.describe(UserUpdateNotifier, type: :model) do
  let!(:user) { create(:user) }

  context "when a user is updated" do
    it "creates database notification" do
      expect { user.update(email: "new@email.com") }.to(change(Noticed::Notification, :count).by(1))
    end

    it "creates email notification" do
      expect { user.update(email: "new@email.com") }.to(change { UserMailer.deliveries.count }.by(1))
    end

    it "sends the proper email subject" do
      user.update(email: "new@email.com")
      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to(eq(I18n.t("mailer.user.updated.subject", event_user: user)))
    end
  end
end
