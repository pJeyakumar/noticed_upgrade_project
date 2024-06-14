class AircraftPolicy < ApplicationPolicy
  def create?
    user.context == "app:dispatch:wing_admin"
  end
  
  def index?
    true
  end

  def show?
    true
  end

end
