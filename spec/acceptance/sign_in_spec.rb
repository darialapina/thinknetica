require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign in
} do
  given(:user) { create(:user) }


end