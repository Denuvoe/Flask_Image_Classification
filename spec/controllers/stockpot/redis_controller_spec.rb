# frozen_string_literal: true

RSpec.describe Stockpot::RedisController, type: :request do
  let(:body) { { status: 200 }.to_json }
  let(:key) { "test" }
  let(:value) { "test_value" }
  let(:field) { "field" }

  describe "GET #index" do
    it "returns the redis value" do
      REDIS.set(key, value)
      get redis_path, params: { key: key }
      expect(response.body).to eq(value.to_json)
      expect(response.status).to eq(200)
    end

    it "returns the redis value with field" do
      REDIS.hset(key, field, value)
      get redis_path, params: { key: key, field: field }
      expect(response.body).to eq(value.to_json)
      expect(response.status).to eq(200)
    end
  end

  describe "POST #create" do
    it "creates a redis hash" do
      post redis_path, params: { key: key, value: value }
      expect(REDIS.get(key)).to eq(value)
      expect(response.status).to eq(200)
    end

    it "creates a redis hash with field" do
      post redis_path, params: { key: key, value: value, field: field }
      expect(REDIS.hget(key, field)).to eq(value)
      expect(response.status).to eq(200)
    end
  end

  describe "GET #keys" do
    it "gets all keys" do
      keys = %w[test1 test2]
      REDIS.set(keys[0], "test1_key")
      REDIS.set(keys[1], "test2_key")

      get redis_keys_path
      expect(JSON.parse(response.body)).to match_array(keys)
    end
  end
end
