require_relative 'acceptance_helper'

feature "User unsubscribe from subscribed question", %q{
  In order to stop following answers for a questions
  As an authenticated user
  I want to be able to unsubscribe from a question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:subscription) { create(:subscription, question: question, user: user) }

  scenario 'Authenticated user subscribes to a question' do
    sign_in(user)
    visit questions_path(question)
    click_link 'Unsubscribe!'

    expect(page).to have_content 'Subscription was successfully destroyed.'
    expect(page).to have_link 'Subscribe!'
  end

  scenario 'Authenticated user wants to unsubscribe from the same question' do
    sign_in(user)
    visit questions_path(question)
    click_link 'Unsubscribe!'

    expect(page).to_not have_link 'Unsubscribe!'
  end

  scenario 'Non-Authenticated user tries to unsubscribe from a question' do
    visit questions_path(question)

    expect(page).to_not have_link 'Unsubscribe!'
  end
end
