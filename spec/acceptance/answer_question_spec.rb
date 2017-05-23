require 'rails_helper'

feature 'answer a question', %q{
  In order to answer a question
  As an authenticated user
  I want to be able to fill in the form on question page
} do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'Authenticated user creates a valid answer' do
    sign_in(user)
    visit question_path(id: question.id)
    fill_in 'Body', with: 'My answer'
    click_on 'Create'

    expect(page).to have_content 'My answer'
  end

  scenario 'Authenticated user creates an invalid answer' do
    sign_in(user)
    visit question_path(id: question.id)
    fill_in 'Body', with: nil
    click_on 'Create'

    expect(page).to have_content "Your answer has an error."
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Visitor tries to create an answer' do
    visit question_path(id: question.id)
    fill_in 'Body', with: 'My answer'
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end