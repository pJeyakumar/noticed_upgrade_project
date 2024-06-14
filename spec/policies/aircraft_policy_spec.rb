require "rails_helper"

describe AircraftPolicy do
  subject { described_class }

  permissions :create? do

    it "grants create if user is an admin" do
      expect(subject).to permit(User.new(context: "app:dispatch:wing_admin"), Aircraft.new(make: "", model: ""))
    end

    it "denies create if user is not an admin" do
      expect(subject).not_to permit(User.new(context: ""), Aircraft.new(make: "", model: ""))
    end
  end
end
