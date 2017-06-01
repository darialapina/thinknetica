require_relative 'acceptance_helper'

feature 'Delete question attachment', %q{
  In order to delete question attachment
  As an authenticated user
  I want to be able to delete attachment to my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  scenario 'Authenticated user deletes attachment to his question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question_attachments' do
      click_on 'Delete'
      expect(page).to_not have_content attachment.file.identifier
    end
  end

  scenario "Authenticated user tries to delete attachment to somebody else's question" do
    other_user = create(:user)
    sign_in(other_user)
    visit question_path(question)

    within '.question_attachments' do
      expect(page).not_to have_link 'Delete'
    end
  end

  scenario 'Non-Authenticated user tries to delete attachment' do
    visit question_path(question)

    within '.question_attachments' do
      expect(page).not_to have_link 'Delete'
    end
  end
end
