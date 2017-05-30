require_relative 'acceptance_helper'

feature 'Delete answer', %q{
  In order to delete answer
  As an authenticated user
  I want to be able to delete my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user deletes his answer', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)
    answer_body = answer.body

    expect(page).to have_content answer_body

    click_on 'Delete'

    expect(page).not_to have_content answer_body
  end

  scenario "Authenticated user tries to delete somebody else's answer" do
    other_user = create(:user)
    sign_in(other_user)
    visit question_path(answer.question)

    expect(page).not_to have_link 'Delete'
  end

  scenario 'Non-Authenticated user tries to delete answer' do
    visit question_path(answer.question)

    expect(page).not_to have_link 'Delete'
  end

end
