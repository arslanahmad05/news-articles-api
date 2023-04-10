# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Article, public: true
    return unless user.admin  # additional permissions for administrators
    can :manage, :all
  end
end
