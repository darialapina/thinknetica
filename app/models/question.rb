class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  include Votable
  include Commentable

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  default_scope { order(:created_at) }

  after_create :autosubscribe_author

  def autosubscribe_author
    Subscription.create!(user: user, question: self)
  end
end
