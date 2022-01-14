
# frozen_string_literal: true

module Stockpot
  class RedisController < MainController
    def index
      if params[:field].present?
        # Returns the value associated with :field in the hash stored at :key
        record = REDIS.hget(params[:key], params[:field])
      else
        # Returns the value of :key
        record = REDIS.get(params[:key])
      end

      render json: record.to_json, status: :ok
    end

    def create
      if params[:field].present?
        # Sets :field in the hash stored at :key to :value
        REDIS.hset(params[:key], params[:field], params[:value])
      else
        # Sets :key to hold the string :value
        REDIS.set(params[:key], params[:value])
      end

      render json: { status: 201 }
    end

    def keys
      record = REDIS.keys

      render json: record.to_json, status: :ok
    end
  end
end