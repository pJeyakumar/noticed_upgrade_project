class AircraftPolicy < ApplicationPolicy
  WING_ADMIN_PERMISSION = "app:dispatch:wing_admin"

  def create?
    user.context == WING_ADMIN_PERMISSION
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
