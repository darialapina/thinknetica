require_relative 'acceptance_helper'
  # - Пользователь может просматривать список вопросов

feature 'User views questions list', %q{
  In order to get around
  As a visitor
  I wart to be able surf though all questions
} do

  given!(:questions) { create_list(:question, 2) }

  scenario 'User navigates to questions page' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
