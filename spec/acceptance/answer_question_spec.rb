require 'rails_helper'

feature 'answer a question', %q{
  In order to answer a question
  As a user
  I want to be able to fill in the form on question page
} do

  given(:question) { create(:question) }

  scenario 'Visitor tries to create answer' do
    visit question_path(id: question.id)
    # save_and_open_page
    fill_in 'Body', with: 'My answer'
    click_on 'Create'
    # save_and_open_page

    expect(page).to have_content 'My answer'
  end

  scenario 'Visitor tries to create invalid answer' do
    visit question_path(id: question.id)
    fill_in 'Body', with: nil
    click_on 'Create'

    expect(page).to have_content "Your answer has an error."
  end
end