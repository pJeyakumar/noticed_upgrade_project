require 'rails_helper'

RSpec.describe NewLogbookEntryCreatedNotification, type: :model do

  let(:delayed_logbook_mailer) { instance_double(NewLogbookEntryCreatedNotification) }

  context 'when logbook entries are created' do

    it 'creates database notifications' do

      user = FactoryBot.create(:user)
      allow(NewLogbookEntryCreatedNotification).to receive(:deliver_later).and_return(delayed_logbook_mailer)
      FactoryBot.create(:logbook_entry)
      expect(delayed_logbook_mailer).to have_received(:deliver_later)

      print
    end

    it 'creates email notifications' do
      print
    end

    it 'uses proper email' do
      print
    end
  end
end

RSpec.describe LogbookEntryUpdatedNotification, type: :model do

  context 'when logbook entries are updated' do

    it 'creates database notifications' do
      print
    end

    it 'creates email notifications' do
      print
    end

    it 'uses proper email' do
      print
    end
  end
end