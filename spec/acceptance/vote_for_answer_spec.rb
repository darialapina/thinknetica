require_relative 'acceptance_helper'

feature 'Vote for answer', %q{
  In order to mark a good answer
  As an authenticated user
  I want to be able to vote for it
} do

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:answer) { create(:answer, user: other_user) }
  given!(:container_class) { 'answers' }

  it_behaves_like "Votable"

  def visit_path
    visit question_path(answer.question)
  end
end