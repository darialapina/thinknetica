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

    within '.answers' do
      fill_in 'Body', with: 'My answer'
      click_on 'Create'
    end

    expect(current_path).to eq question_path(question)

    within '.answers' do
      expect(page).to have_content 'My answer'
      expect(page).not_to have_content "Body can't be blank"
    end
  end

  scenario 'Authenticated user creates an invalid answer', js: true do
    sign_in(user)

    visit question_path(question)
    within '.answers' do
      fill_in 'Body', with: nil
      click_on 'Create'
    end

    expect(current_path).to eq question_path(question)
    within '.answers_errors' do
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Visitor tries to create an answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Give an answer'
  end

  context 'mulitple sessions' do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('other_user') do
        other_user = create(:user)
        sign_in(other_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers' do
          fill_in 'Body', with: 'My answer'
          click_on 'Create'
        end

        within '.answers' do
          expect(page).to have_content 'My answer'
          expect(page).not_to have_content "Body can't be blank"
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'My answer'
        end
      end

      Capybara.using_session('other_user') do
        within '.answers' do
          expect(page).to have_content 'My answer'
          expect(page).to have_content 'Up'
          expect(page).to have_content 'Down'
        end
      end
    end
  end

end
