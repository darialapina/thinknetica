class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  default_scope { order('is_best DESC') }

  def set_best
    Answer.transaction do
      self.question.answers.update_all(is_best: false)
      self.update(is_best: true)
    end
  end
end
