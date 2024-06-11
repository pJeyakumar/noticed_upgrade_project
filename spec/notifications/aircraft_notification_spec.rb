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

    it 'generates mail' do

      FactoryBot.create(:user, first_name: "Sally")

      # FactoryBot.create(:aircraft)
      # expect { FactoryBot.create(:aircraft) }.to have_enqueued_job(NewAircraftCreatedNotification).on_queue('default').exactly(:once)
      #
      # # Email Notification
      # expect{ FactoryBot.create(:aircraft) }.to change { ActionMailer::Base.deliveries.count }.by(1)
      #
      # email = ActionMailer::Base.deliveries.last
      # expect(email.subject).to include("[DIGITAL FLIGHT SIM] New Aircraft Created:") # replace by translated comment


      expect{ FactoryBot.create(:aircraft) }.to change { Notification.count }.by(1)
      print

      # FactoryBot.create(:aircraft)
      #
      # # expect { FactoryBot.create(:aircraft) }.to change { AircraftMailer.deliveries.count }.by(1)

      #
      # # expect { FactoryBot.create(:aircraft) }.to change { AircraftMailer.deliveries.count }.by(1)
      # expect { FactoryBot.create(:aircraft) }.to(
      #   have_enqueued_job.on_queue('default').with(
      #     'YourMailer', 'your_method', 'deliver_now',
      #     )
      # )
      #
      # # THIS WORKS
      # expect {
      #   FactoryBot.create(:aircraft)
      # }.to change {
      #   ActiveJob::Base.queue_adapter.enqueued_jobs.count
      # }.by 1
    end


    it 'generates a prpoer email payload' do

      FactoryBot.create(:user, first_name: "Sally")
      FactoryBot.create(:aircraft)

      email = AircraftMailer.deliveries.last
      expect(email.to).to include(user.email)
      expect(email.subject).to include('New Aircraft Created')
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
      FactoryBot.create(:user)
      expect(Notification.last.type).to eq("UserSignUpNotification")

      # creates 2 notofications, both type UserSignUpNotification
      # why 2? maybe after_create and after_update both firing? likely... they have the same data
      # User update

    end

    #   # it 'uses the correct notification template'
    #   #   # todo ...
    #   # end

  end
end