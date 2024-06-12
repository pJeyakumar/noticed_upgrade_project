require "rails_helper"

RSpec.describe(LogbookEntryUpdatedNotification, type: :model) do
  let!(:logbook_entry) { create(:logbook_entry) }

  context "when logbook entries are updated" do
    it "creates database notifications" do
      expect { logbook_entry.update(duration: 666) }.to(change(Notification, :count).by(1))
    end

    it "creates email notifications" do
      expect { logbook_entry.update(duration: 666) }.to(change { LogbookEntryMailer.deliveries.count }.by(1))
    end

    it "uses the proper email subject" do
      logbook_entry.update(duration: 666)
      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to(eq(I18n.t("mailer.logbook_entry.updated.subject", pilot: logbook_entry.pilot_in_command)))
    end
  end
end
