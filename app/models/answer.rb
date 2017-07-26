class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  include Votable
  include Commentable

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  default_scope { order('best DESC') }

  after_create :inform_subscribers

  def set_best
    Answer.transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end

  def inform_subscribers
    InformSubscribersJob.perform_later(self)
  end
end
