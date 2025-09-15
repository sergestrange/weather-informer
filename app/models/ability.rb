# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new(role: 'viewer')

    if user.admin?
      can :manage, :all
    else
      can :read, City
      can :weather, City
    end
  end
end
