require 'rails_helper'

RSpec.describe UserSignUpNotification, type: :model do

  context 'when a new user signs up' do

    it 'creates database notifications' do
      expect{ FactoryBot.create(:user) }.to change { Notification.count }.by(1)
    end

    it 'creates email notifications' do
      expect { FactoryBot.create(:user) }.to change { UserMailer.deliveries.count }.by(1)
    end

    it 'sends the proper email subject' do
      FactoryBot.create(:user)
      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to include("New User Created") # replace by translated comment
    end
  end
end


RSpec.describe UserUpdateNotification, type: :model do

  let!(:user) { FactoryBot.create(:user) }

  context 'when a user is updated' do

    it 'creates database notification' do
      expect{ user.update(email: "new@email.com") }.to change { Notification.count }.by(1)
    end

    it 'creates email notification' do
      expect { user.update(email: "new@email.com") }.to change { UserMailer.deliveries.count }.by(1)
    end

    it 'sends the proper email subject' do
      ActionMailer::Base.deliveries.clear
      user.update(email: "new@email.com")
      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to include("User Updated") # replace by translated comment
    end
  end
end