# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :aircraft

  def initialize(user, aircraft)
    @user = user
    @aircraft = aircraft
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise(NoMethodError, "You must define #resolve in #{self.class}")
    end

    private

    attr_reader :user, :scope
  end
end
