require_relative 'acceptance_helper'

feature "User subscribe to a question", %q{
  In order to follow answers for a questions
  As an authenticated user
  I want to be able to subscribe to a question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user subscribes to a question' do
    sign_in(user)
    visit question_path(question)
    click_link 'Subscribe!'

    expect(page).to have_content 'Subscription was successfully created.'
  end

  scenario 'Authenticated user wants to subscribe to the same question' do
    sign_in(user)
    visit question_path(question)
    click_link 'Subscribe!'

    expect(page).to_not have_link 'Subscribe!'
  end

  scenario 'Non-Authenticated user tries to subscribe to a question' do
    visit question_path(question)

    expect(page).to_not have_link 'Subscribe!'
  end
end
