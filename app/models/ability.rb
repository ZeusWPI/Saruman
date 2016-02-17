class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user
    alias_action :new, :create, :read, :update, :destroy, :to => :crud

    case user.role
    when 'admin'
      # Admins can manage all
      can :manage, :all

    when 'partner'
      # Partners can only show their user
      can :show, User, id: user.id

      # And crud their own registrations if there is no deadline or the
      # deadline hasn't expired yet
      can :crud, Reservation, user: user unless Settings.instance.expired?
    end
  end
end
