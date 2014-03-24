class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :new, :create, :read, :update, :destroy, :to => :crud

    unless user.nil?
      case user.role
      when 'admin'
        # Admins can manage all
        can :manage, :all
      when 'partner'
        # Partners can only show their user
        can :show, User, id: user.id
        # And crud their own registrations
        can :crud, Reservation, user_id: user.id
      end
    end
  end
end
