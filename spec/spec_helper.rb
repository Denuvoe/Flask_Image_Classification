
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

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end