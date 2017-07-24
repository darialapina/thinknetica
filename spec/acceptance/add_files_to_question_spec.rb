require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given!(:container_class) { 'question_attachments' }

  it_behaves_like "Attachable"

  def visit_path
    visit new_question_path
  end

  def fill_the_form
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
  end
end