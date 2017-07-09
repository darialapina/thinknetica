require_relative 'acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake in question
  As an author of question
  I'd like ot be able to edit my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user tries to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to Edit' do
      within '.question' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tries to edit his question' do
      within '.question' do
        click_on 'Edit'
      end
      fill_in 'Body', with: 'edited question body'
      click_on 'Save'

      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question body'
    end

    scenario 'tries to edit his question with invalid body' do
      within '.question' do
        click_on 'Edit'
      end
      fill_in 'Body', with: ''
      click_on 'Save'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Authenticated user tries to edit other user's question" do
    other_user = create(:user)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
