class Ability
  include CanCan::Ability

  def initialize(member)
       member ||= Member.new # guest member (not logged in)
       if member.admin?
         can :manage, :all
       else
         can :manage, Member, :id        => member.id
         can :manage, Cert,   :member_id => member.id
         can :read,   :all
       end

#    The first argument to `can` is the action you are giving the member permission to do.
#    If you pass :manage it will apply to every action. Other common actions here are
#    :read, :create, :update and :destroy.

#    The second argument is the resource the member can perform the action on. If you pass
#    :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
#
#    The third argument is an optional hash of conditions to further filter the objects.
#    For example, here the member can only update published articles.

#       can :update, Article, :published => true

#    See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
