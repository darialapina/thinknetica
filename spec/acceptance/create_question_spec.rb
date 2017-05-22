require 'rails_helper'
  # - Пользователь может создавать вопрос

feature "User create question", %q{
  In order to get answers
  As anyone #yet
  I want to be able to create a question
} do

  scenario 'Visitor tries to create a valid question' do
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Visitor tries to create an invalid question' do
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content 'Your question has errors.'
  end
end