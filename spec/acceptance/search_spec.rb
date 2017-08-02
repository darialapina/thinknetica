require_relative 'acceptance_helper'

feature 'Full-text search', %q{
  In order to find importaint information
  As an visitor
  I'd like to be able to make full-text requests
} do

  given!(:user) { create(:user, email: "test@test.com") }
  given!(:question) { create(:question, title: "test") }
  given!(:answer) { create(:answer, body: "test") }
  given!(:comment) { create(:comment, commentable: question, body: "test") }

  scenario 'Visitor is searching through all', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      expect(page).to have_button 'Find!'

      select 'All', from: 'for'
      fill_in 'query', with: 'test'
      click_on 'Find!'

      expect(page).to have_content 'Question'
      expect(page).to have_content question.title
      expect(page).to have_content 'Answer'
      expect(page).to have_content answer.body
      expect(page).to have_content 'Comment'
      expect(page).to have_content comment.body
      expect(page).to have_content 'User'
      expect(page).to have_content user.email
    end
  end

  %w(Answer Question User Comment).each do |attr|
    scenario "Visitor is searching for #{attr}", js: true do
      ThinkingSphinx::Test.run do
        visit root_path

        select attr, from: 'for'
        fill_in 'query', with: 'test'
        click_on 'Find!'

        expect(page).to have_content attr
      end
    end
  end
end