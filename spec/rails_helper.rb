# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'factory_bot'
require 'timecop'
require 'pry'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('dummy/config/environment', __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

RSpec.configure do |config|
  config.include Stockpot::Engine.routes.url_helpers
  co