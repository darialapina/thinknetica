require 'rails_helper'

feature 'Delete question', %q{
  In order to delete question
  As an authenticated user
  I want to be able to delete my question
  } do

  # given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'Authenticated user deletes his question' do
    sign_in(user)
    @questions = create(:question, user: user)
    visit questions_path
    click_on 'Delete'

    expect(page).to have_content 'Your question was successfully deleted.'
  end

  scenario "Authenticated user tries to delete somebody else's question" do
    sign_in(user)
    other_user = create(:user)
    @questions = create(:question, user: other_user)
    visit questions_path
    # click_on 'Delete'
    # expect(page).not_to have_content 'Your question was successfully deleted.'
    expect(page).not_to have_link "Delete"
    # save_and_open_page
  end

  scenario 'Non-Authenticated user tries to delete question' do
    visit questions_path
    expect(page).not_to have_link "Delete"
  end
end