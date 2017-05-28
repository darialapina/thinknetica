class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def set_best
    self.question.answers.update_all(is_best: false)
    self.update(is_best: true)
  end
end
