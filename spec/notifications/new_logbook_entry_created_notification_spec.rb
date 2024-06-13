require "rails_helper"

RSpec.describe(NewLogbookEntryCreatedNotification, type: :model) do
  let(:logbook_entry) { create(:logbook_entry) }

  context "when logbook entries are created" do
    it "creates database notifications" do
      # Two notifications expected because a User must exist for a Logbook_Entry to be created
      expect { logbook_entry }.to(change(Notification, :count).by(2))
    end

    it "creates database notifications of the right type" do
      logbook_entry
      # the first notification will be for the user created, the second notification will pertain to the logbook
      expect(Notification.second.type).to(eq("NewLogbookEntryCreatedNotification"))
    end

    it "creates email notifications" do
      expect { logbook_entry }.to(change { LogbookEntryMailer.deliveries.count }.by(2))
    end

    it "uses the proper email subject" do
      logbook_entry
      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to(eq(I18n.t("mailer.logbook_entry.created.subject", pilot: logbook_entry.pilot_in_command)))
    end
  end
end
