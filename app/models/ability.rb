class Ability
  include CanCan::Ability

  def initialize(entity)
    alias_action :new, :create, :read, :update, :destroy, :to => :crud

    # Delegate with user precedence
    if not entity.nil? and entity.kind_of? User
      user_rules(entity)
    elsif entity.kind_of? Partner
      partner_rules(entity)
    end
  end

  def user_rules(user)
    # Users can do everything
    can :manage, Partner
    can :manage, Item
    can :manage, Reservation
  end

  def partner_rules(partner)
    can :read, Partner, id: partner.id
    can :manage, Reservation, partner_id: partner.id
  end
end
