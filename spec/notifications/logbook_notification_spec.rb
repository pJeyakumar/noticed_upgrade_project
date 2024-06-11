require 'rails_helper'

RSpec.describe NewLogbookEntryCreatedNotification, type: :model do

  context 'when logbook entries are created' do

    it 'creates database notifications' do
      # Will create an airplane notification, and logbook notification
      expect{ FactoryBot.create(:logbook_entry) }.to change { Notification.count }.by(2)
    end

    it 'creates email notifications' do
      # TODO: make sure I understand why 2 here
      expect { FactoryBot.create(:logbook_entry) }.to change { LogbookEntryMailer.deliveries.count }.by(2)
    end

    it 'uses the proper email subject' do
      FactoryBot.create(:logbook_entry)
      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to include("New Logbook Entry By") # replace by translated comment
    end
  end
end

RSpec.describe LogbookEntryUpdatedNotification, type: :model do

  let!(:logbook_entry) { FactoryBot.create(:logbook_entry) }

  context 'when logbook entries are updated' do

    it 'creates database notifications' do
      expect{ logbook_entry.update(duration: 666) }.to change { Notification.count }.by(1)
    end

    it 'creates email notifications' do
      expect{ logbook_entry.update(duration: 666) }.to change { LogbookEntryMailer.deliveries.count }.by(1)
    end

    it 'uses the proper email subject' do
      logbook_entry.update(duration: 666)
      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to include("s Logbook Entry") # replace by translated comment
    end
  end
end