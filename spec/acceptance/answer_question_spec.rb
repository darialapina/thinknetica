require_relative 'acceptance_helper'

feature 'answer a question', %q{
  In order to answer a question
  As an authenticated user
  I want to be able to fill in the form on question page
} do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'Authenticated user creates a valid answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'My answer'
    click_on 'Create'

    expect(current_path).to eq question_path(question)

    within '.answers' do
      expect(page).to have_content 'My answer'
    end

    expect(page).not_to have_content "Body can't be blank"
  end

  scenario 'Authenticated user creates an invalid answer', js: true do
    sign_in(user)
    # sleep(1)
    visit question_path(question)
    fill_in 'Body', with: nil
    click_on 'Create'

    expect(current_path).to eq question_path(question)
    within '.errors' do
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Visitor tries to create an answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Give an answer'
  end
end
