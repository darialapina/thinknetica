require_relative 'acceptance_helper'
  # - Пользователь может создавать вопрос

feature "User create question", %q{
  In order to get answers
  As an authenticated user
  I want to be able to create a question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates a valid question' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
    click_on 'Create'

    expect(page).to have_content 'Your question was successfully created.'
  end

  scenario 'Authenticated user creates an invalid question' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content 'Your question has errors.'
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-Authenticated user tries to create a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
