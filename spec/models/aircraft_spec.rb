require 'rails_helper'

RSpec.describe Aircraft, type: :model do
  let(:aircraft) { FactoryBot.build(:aircraft) }

  context 'Should validate' do
    it 'with make, model present' do
      expect(aircraft).to be_valid
    end

  end

    context 'Should not be valid' do
        it 'when model is not present' do
        aircraft.model = nil
        expect(aircraft).not_to be_valid
        end
    end

end