require 'rails_helper'

RSpec.describe NewAircraftCreatedNotification, type: :model do

  context 'when aircraft are created' do
    it 'creates notifications' do

      # Must eagerly create a user first, or notifications will not be created
      user = FactoryBot.create(:user)
      aircraft = FactoryBot.create(:aircraft)

      # TODO: instead of count, very actual contents of notifications
      # Note also, notifications temporarily set to User.all

      expect(aircraft).to be_valid
      expect(user).to be_valid
      expect(Notification.count).to be(3)

      FactoryBot.create(:aircraft)
      expect(Notification.count).to be(4)
    end

    it 'notifies the correct user' do
      # Note, notification is temporarily User.All
      FactoryBot.create(:user, first_name: "Sally")
      FactoryBot.create(:aircraft)
      expect(Notification.last.recipient.first_name).to eq("Sally")
    end

    it 'the notification is the correct type' do

      # New Aircraft
      FactoryBot.create(:aircraft)
      expect(Notification.last.recipient_type).to eq("User")

      # Logbook entry updated
      FactoryBot.create(:logbook_entry)
      expect(Notification.last.type).to eq("NewLogbookEntryCreatedNotification")


      # Logbook entry created

      # User signup

      # User update

    end

    #   # it 'uses the correct notification template'
    #   #   # todo ...
    #   # end


  end
end