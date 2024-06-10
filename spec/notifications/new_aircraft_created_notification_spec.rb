require 'rails_helper'

RSpec.describe NewAircraftCreatedNotification, type: :model do

  # Must eagerly create a user first, or notifications will not be created
  let!(:user) { FactoryBot.create(:user) }

  let!(:aircraft) { FactoryBot.create(:aircraft) }
  
  context 'when aircraft are created' do
    it 'creates notifications' do
      expect(aircraft).to be_valid
      expect(user).to be_valid
      expect(Notification.count).to be(1)

      FactoryBot.create(:aircraft) 
      expect(Notification.count).to be(2)
    end

    it 'notifies the correct user' do
      FactoryBot.create(:user, first_name: "Sally")
      FactoryBot.create(:aircraft)
      expect(Notification.last.recipient.first_name).to eq("Sally")
    
    # make sure it goes to all users
    # 
    
    end

    # it 'uses the correct notification template'
    #   # todo ...
    # end


    # is the notification the right type


    # does this object exist, ... 


  end
end