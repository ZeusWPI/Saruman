class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :new, :create, :read, :update, :destroy, :to => :crud

    # Users can do everything
    unless user.nil?
      can :manage, Partner
    end

  end
end
