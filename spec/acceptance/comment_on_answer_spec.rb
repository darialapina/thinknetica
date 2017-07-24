require_relative 'acceptance_helper'

feature 'Comment on an answer', %q{
  In order to discuss the answer
  As an authenticated user
  I want to be able to leave comments
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:container_class) { 'answer_comments' }

  it_behaves_like "Commentable"
end
