require_relative 'acceptance_helper'

feature 'Comment on question', %q{
  In order to discuss the question
  As an authenticated user
  I want to be able to leave comments
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Unauthenticated user tries to add comment' do
    visit question_path(question)

    within '.question_comments' do
      expect(page).not_to have_content 'Add a comment'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees add comment form' do
      within '.question_comments' do
        expect(page).to have_content 'Add a comment'
      end
    end

    scenario 'leaves a valid comment', js: true do
      within '.question_comments' do
        fill_in 'Comment', with: 'My comment'
        click_on 'Create'

        expect(page).to have_content 'My comment'
        expect(page).not_to have_content "Body can't be blank"
      end
    end

    scenario 'leaves an invalid comment', js: true do
      within '.question_comments' do
        fill_in 'Comment', with: ''
        click_on 'Create'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  context 'mulitple sessions' do
    scenario "comment to a question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question_comments' do
          fill_in 'Comment', with: 'My comment'
          click_on 'Create'

          expect(page).to have_content 'My comment'
          expect(page).not_to have_content "Body can't be blank"
        end
      end

      Capybara.using_session('guest') do
        within '.question_comments' do
          expect(page).to have_content 'My comment'
        end
      end
    end
  end

end