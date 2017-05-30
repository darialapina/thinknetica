require_relative 'acceptance_helper'
  #  - Пользователь может просматривать вопрос и ответы к нему.

feature 'Vititor views question', %q{
  In order to find solution
  As a visitor
  I want to be able views question with answers
} do

  given(:question) { create :question }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'User visits question page' do
    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)

    question.answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end

end
