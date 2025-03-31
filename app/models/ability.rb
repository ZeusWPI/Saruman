class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user
    alias_action :new, :create, :read, :update, :destroy, :resend, to: :crud

    case user.role
    when 'admin'
      # Admins can manage all
      can :manage, :all

    when 'partner'
      # Partners can only crud their user
      can :crud, Partner do |p|
        p.users.include?(user)
      end

      can :crud, User do |u|
        u.partner.users.include?(user)
      end

      # And crud their own registrations if there is no deadline or the
      # deadline hasn't expired yet
      can :crud, Reservation, partner: user.partner unless Settings.instance.expired?
    end
  end
end
