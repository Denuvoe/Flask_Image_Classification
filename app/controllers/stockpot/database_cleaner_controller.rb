# frozen_string_literal: true

module Stockpot
  class DatabaseCleanerController < MainController
    # Clean database before, between, and after tests by clearing Rails
    # and REDIS caches and truncating the active record database.
    def index
      clear_cache_and_redis
      clean_database
      render json: { status: 204 }
    end

    private

    def clear_cache_and_redis
      DatabaseCleaner