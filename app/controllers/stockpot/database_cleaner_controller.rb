# frozen_string_literal: true

module Stockpot
  class DatabaseCleanerController < MainController
    # Clean database before, between, and after tests by clearing Rails
    # and REDIS caches and truncat