class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def author_of?(thing)
    self.id == thing.user_id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info.try(:[], :email)
    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    elsif email

      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)

      user.create_authorization(auth)
      user.send_confirmation_instructions
    else
      password = Devise.friendly_token[0, 20]
      user = User.create(password: password, password_confirmation: password)
    end

    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
