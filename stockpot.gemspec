# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "stockpot/version"

Gem::Specification.new do |spec|
  spec.name          = "stockpot"
  spec.version       = Stockpot::VERSION
  spec.authors       = [ "Jayson Smith", "Brian Herman", "Derek Campbell", "Victor Santana" ]
  spec.email         = [ "gh@nes.33mail.com", "victorfrank.santanalugo@gmail.com" ]

  spec.summary       = "Makes setting up test data in your Rails database from an external resource easier."
  spec.description   = "Exposes a few end points from your app, easily enabling CRUD actions on your database that you can utilize from things like a standalone test suite to set up state. (think: Cypress, Cucumber, etc.)"
  spec.homepage      = "