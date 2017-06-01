require_relative 'acceptance_helper'

feature 'Delete answer attachment', %q{
  In order to delete answer attachment
  As an authenticated user
  I want to be able to delete attachment to my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario 'Authenticated user deletes attachment to his answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      within "li#attachment_#{attachment.id}" do
        click_on 'Delete'
      end
      expect(page).to_not have_content attachment.file.identifier
    end
  end

  scenario "Authenticated user tries to delete attachment to somebody else's answer" do
    other_user = create(:user)
    sign_in(other_user)
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link 'Delete'
    end
  end

  scenario 'Non-Authenticated user tries to delete attachment' do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link 'Delete'
    end
  end
end
