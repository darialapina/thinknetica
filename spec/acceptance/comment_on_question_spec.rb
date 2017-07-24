require_relative 'acceptance_helper'

feature 'Comment on question', %q{
  In order to discuss the question
  As an authenticated user
  I want to be able to leave comments
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:container_class) { 'question_comments' }

  it_behaves_like "Commentable"
end
