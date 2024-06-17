class AircraftPolicy < ApplicationPolicy
  AIRCRAFT_PERM_STRING = "app:dispatch:wing_admin"

  def create?
    user.context == AIRCRAFT_PERM_STRING
  end

  def index?
    true
  end

  def show?
    true
  end

  def update?
    create?
  end
end
