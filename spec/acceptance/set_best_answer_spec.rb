require_relative 'acceptance_helper'

feature 'Set best answer', %q{
  In order to pick correct answer
  As an author of question
  I want to be able to select best answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'Unauthenticated user tries to select answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_selector('input[type=radio]')
    end
  end

  describe 'Authenticated author' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees radio buttons' do
      within '.answers' do
        expect(page).to have_selector('input[type=radio]')
      end
    end

    scenario 'sets best answer', js: true do
      other_answer = create(:answer, question: question)
      visit question_path(question)

      within '.answers' do
        # answer = question.answers.last
        within "#answer_#{other_answer.id}" do
          choose 'is_best'
        end
        expect(page).to have_content "You've set the best answer"
        expect(page.first(:css, 'li')).to have_content other_answer.body
      end
    end

    scenario 'changes best answer', js: true do
      answer = question.answers.last
      other_answer = create(:answer, question: question, is_best: true)
      visit question_path(question)

      within '.answers' do
        within "#answer_#{answer.id}" do
          choose 'is_best'
        end
        expect(page).to have_content "You've set the best answer"
        expect(page.first(:css, 'li')).to have_content answer.body
      end
    end
  end

  scenario "Authenticated user tries to set best answer to other user's question" do
    other_user = create(:user)
    sign_in other_user
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_selector('input[type=radio]')
    end
  end

end