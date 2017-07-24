require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:container_class) { 'answers' }

  it_behaves_like "Attachable"

  def visit_path
    visit question_path(question)
  end

  def fill_the_form
    fill_in 'Body', with: 'My answer'
  end
end