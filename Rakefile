# frozen_string_literal: true

begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

APP_RAKEFILE = File.expand_path("spec/dummy/Rakefile", __dir__)

require File.expand_path("../spec/dummy/config/application", __FILE__)
require "bundler/gem_tasks"

load "rail