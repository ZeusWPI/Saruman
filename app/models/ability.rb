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

        # And crud their own registrations if there is no deadline or the
        # deadline hasn't expired yet
        can :crud, Reservation do |r|
          r.user.id == user.id and (Settings.instance.deadline.blank? or Settings.instance.deadline >= DateTime.now)
        end

      end
    end
  end
end
