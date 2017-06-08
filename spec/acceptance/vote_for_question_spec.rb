require_relative 'acceptance_helper'

feature 'Vote for questions', %q{
  In order to mark a good question
  As an authenticated user
  I want to be able to vote for it
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user (not author) votes for a question', js: true do
    sign_in(user)
    visit questions_path
    # save_and_open_page

    click_on 'Up'
    expect(page).to have_content 'Rate: 1'
    expect(page).to_not have_content 'Up'
    expect(page).to have_content 'Reset'
    expect(page).to_not have_content 'Down'

    click_on 'Reset'
    expect(page).to have_content 'Rate: 0'
    expect(page).to_not have_content 'Reset'
    expect(page).to have_content 'Up'
    expect(page).to have_content 'Down'

    click_on 'Down'
    expect(page).to have_content 'Rate: 1'
    expect(page).to_not have_content 'Down'
    expect(page).to_not have_content 'Up'
    expect(page).to have_content 'Reset'
  end

  scenario 'Author tries to vote', js: true do
    sign_in(question.user)
    visit questions_path

    expect(page).to have_content 'Rate: 0'
    expect(page).to_not have_content 'Up'
    expect(page).to_not have_content 'Reset'
    expect(page).to_not have_content 'Down'
  end

  scenario 'Non-authenticated user tries to vote', js: true do
    visit questions_path

    expect(page).to have_content 'Rate: 0'
    expect(page).to_not have_content 'Up'
    expect(page).to_not have_content 'Reset'
    expect(page).to_not have_content 'Down'
  end


end