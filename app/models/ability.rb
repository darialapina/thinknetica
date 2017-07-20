class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer], user: user
    can :set_best, Answer do |answer|
      answer.question.user_id == user.id
    end

    can :destroy, Attachment do |attachment|
      attachment.attachable.user_id == user.id
    end

    can :create, Vote do |vote|
      vote.votable.user_id != user.id
    end

    can :reset, Vote, user: user

    can :manage, :profile
  end
end
