require 'rails_helper'

feature 'User registration', %q{
  In order to ask questions and give answers
  As a visitor
  I wart to be able to register
} do

  scenario 'Visitor tries to sign up' do
    visit new_user_registration_path

    fill_in 'Email', with: '123@test.com'
    fill_in 'Password', with: '123123123'
    fill_in 'Password confirmation', with: '123123123'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

end
