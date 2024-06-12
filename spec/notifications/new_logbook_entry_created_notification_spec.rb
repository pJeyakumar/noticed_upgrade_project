require "rails_helper"

RSpec.describe(NewLogbookEntryCreatedNotification, type: :model) do
  context "when logbook entries are created" do
    it "creates database notifications" do
      # Will create an airplane notification, and logbook notification
      expect { create(:logbook_entry) }.to(change(Notification, :count).by(2))
    end

    it "creates email notifications" do
      # TODO: make sure I understand why 2 here
      expect { create(:logbook_entry) }.to(change { LogbookEntryMailer.deliveries.count }.by(2))
    end

    it "uses the proper email subject" do
      logbook_entry = create(:logbook_entry)
      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to(eq( I18n.t("mailer.logbook_entry.created.subject", pilot: logbook_entry.pilot_in_command)))
    end
  end
end
