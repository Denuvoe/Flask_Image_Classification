
require 'database_cleaner/active_record'
require 'database_cleaner/redis'
require 'support/assertion_helpers'
require 'support/api_helpers.rb'
require 'support/factory_bot.rb'

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.include AssertionHelpers
  config.include ApiHelpers, type: :request

  config.before(:suite) do
    DatabaseCleaner[:active_record].clean_with(:truncation)
    DatabaseCleaner[:redis].clean_with(:deletion)
  end

  config.before(:each) do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner[:redis].strategy = :deletion
  end