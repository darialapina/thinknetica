require_relative 'acceptance_helper'

feature 'Vote for questions', %q{
  In order to mark a good question
  As an authenticated user
  I want to be able to vote for it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user votes for a question', js: true do
    sign_in(user)
    visit questions_path

    # choose
  end

end