class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :new, :create, :read, :update, :destroy, :to => :crud

    unless user.nil?
      case user.role
      when 'admin'
        can :manage, User
        can :manage, Item
        can :manage, Reservation
      when 'partner'
        can :show, User, id: user.id
        can :crud, Reservation, user_id: user.id
      end
    end
  end
end
