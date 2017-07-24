require_relative 'acceptance_helper'

feature 'Vote for questions', %q{
  In order to mark a good question
  As an authenticated user
  I want to be able to vote for it
} do

  given(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: other_user) }
  given!(:container_class) { 'questions-list' }

  it_behaves_like "Votable"

  def visit_path
    visit questions_path
  end
end