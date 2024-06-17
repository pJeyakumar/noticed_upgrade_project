require "rails_helper"

describe AircraftPolicy do
  subject(:policy) { described_class }

  let(:aircraft) { build(:aircraft) }
  let(:user) { create(:user) }
  let(:admin) { create(:user, context: AircraftPolicy::AIRCRAFT_PERM_STRING) }

  permissions :create? do
    it "grants create if user is an admin" do
      expect(policy).to(permit(admin, aircraft.save))
    end

    it "denies create if user is not an admin" do
      expect(policy).not_to(permit(user, aircraft.save))
    end
  end
end
