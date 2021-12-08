# frozen_string_literal: true

begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

APP_RAKEFILE = File.expand_path("spec/dummy/Rakefile", __dir__)

require File.expand_path("../spec/dummy/config/application", __FILE__)
require "bundler/gem_tasks"

load "rails/tasks/engine.rake"

Bundler::GemHelper.install_tasks

task :release do
  sh "bundle exec rake release"
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  puts "