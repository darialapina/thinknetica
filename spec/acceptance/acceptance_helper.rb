require 'rails_helper'

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit
  Capybara.server = :puma
  Capybara.server_host = "0.0.0.0"
  Capybara.server_port = 4545
  Capybara.default_wait_time = 5

  config.include AcceptanceMacros, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # config.before(:each, :sphinx => true) do
  #   # For tests tagged with Sphinx, use deletion (or truncation)
  #   DatabaseCleaner.strategy = :deletion
  # end
end