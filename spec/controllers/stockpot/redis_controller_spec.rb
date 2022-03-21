# frozen_string_literal: true

RSpec.describe Stockpot::RedisController, type: :request do
  let(:body) { { status: 200 }.to_json }
  let(:key) { "test" }
  let(:value) { "test_value" }
  let(:field) { "field" }

  describe "GET #index" do
    it "returns the redis value" do
      REDIS.set(key, value)
      get redis_path, params: { key: k