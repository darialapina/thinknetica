require_relative 'acceptance_helper'

feature 'Vote for answer', %q{
  In order to mark a good answer
  As an authenticated user
  I want to be able to vote for it
} do

  given(:user) { create(:user) }
  given!(:answer) { create(:answer) }

  scenario 'Authenticated user (not author) votes for a answer', js: true do
    sign_in(user)
    visit question_path(answer.question)

    within '.answers' do
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
      expect(page).to have_content 'Rate: -1'
      expect(page).to_not have_content 'Down'
      expect(page).to_not have_content 'Up'
      expect(page).to have_content 'Reset'
    end
  end

  scenario 'Author tries to vote' do
    sign_in(answer.user)
    visit question_path(answer.question)

    within '.answers' do
      expect(page).to have_content 'Rate: 0'
      expect(page).to_not have_content 'Up'
      expect(page).to_not have_content 'Reset'
      expect(page).to_not have_content 'Down'
    end
  end

  scenario 'Non-authenticated user tries to vote' do
    visit question_path(answer.question)

    within '.answers' do
      expect(page).to have_content 'Rate: 0'
      expect(page).to_not have_content 'Up'
      expect(page).to_not have_content 'Reset'
      expect(page).to_not have_content 'Down'
    end
  end


end