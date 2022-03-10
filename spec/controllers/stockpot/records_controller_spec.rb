
# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stockpot::RecordsController, type: :request do
  let(:json_headers) { { "CONTENT_TYPE": "application/json" } }
  let(:address) { create(:address) }
  let(:second_address) { create(:address, city: "New York City") }
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:user_admin) { create(:users_admin) }
  let(:expected) do
    {
      status: 400,
      message: "You need to provide at least one model name as an argument",
      backtrace: "No backtrace",
    }
  end

  before do
    ## This allows us to trigger the errors in transactions without
    # the logging part. (which may confuse people that run the spec file)
    allow_any_instance_of(Logger).to receive(:warn).and_return(nil)
  end

  describe "POST #records" do
    it "requires a factory be specified to create the record" do
      expected = {
        status: 400,
        backtrace: "No backtrace",
        message: "You need to provide at least one factory name as an argument",
      }

      post records_path, params: {}.to_json, headers: json_headers
      check_error_response(response, expected)
    end

    it "calls a factory and return the record" do
      first_name = "firstName1"
      last_name = "lastName1"
      params = {
        factories: [
          {
            factory: "user",
            attributes: [
              {
                first_name: first_name,
                last_name: last_name,
              },
            ],
          },
        ],
      }

      post records_path, params: params.to_json, headers: json_headers
      expect(response.status).to be 202
      expect(User.last.first_name).to eql(first_name)
      expect(json_body["users"][0]["first_name"]).to eq(first_name)
      expect(json_body["users"][0]["last_name"]).to eq(last_name)
    end

    it "creates multiple records" do
      first_name1 = "firstName1"
      last_name1 = "lastName1"
      first_name2 = "firstName2"
      last_name2 = "lastName2"
      params = {
        factories: [
          {
            list: 2,
            factory: "user",
            attributes: [
              {
                first_name: first_name1,
                last_name: last_name1,
              },
              {
                first_name: first_name2,
                last_name: last_name2,
              },
            ],
          },
        ],
      }.to_json

      post records_path, params: params, headers: json_headers
      expect(response.status).to be 202
      expect(User.all.count).to be(2)
      expect(json_body["users"][0]["first_name"]).to eq(first_name1)
      expect(json_body["users"][0]["last_name"]).to eq(last_name1)
      expect(json_body["users"][1]["first_name"]).to eq(first_name2)
      expect(json_body["users"][1]["last_name"]).to eq(last_name2)
    end

    it "rolls back transactions if an error is triggered" do
      params = {
        factories: [
          {
            list: 2,
            factory: "user",
            attributes: [
              {
                first_name: "first_name_1",
                last_name: "last_name_1",
              },
              {
                first_name: "no",
                last_name: "last_name_2",
              },
            ],
          },
        ],
      }.to_json

      post records_path, params: params, headers: json_headers
      expect(response.status).to be 417
      expect(User.all.count).to be(0)
    end
  end

  describe "GET #records" do
    it "requires a model be specified to retrieve a record" do
      get records_path, params: {}.to_json, headers: json_headers
      check_error_response(response, expected)
    end

    it "can return multiple records of the same model" do
      user
      second_user
      params = {
        models: [
          {
            model: "user",
          },
        ],
      }

      get records_path, params: params, headers: json_headers
      expect(response.status).to be 200
      expect(json_body["users"].count).to eq(2)
    end

    it "can return multiple records of differing models" do
      address
      params = {
        models: [
          {
            model: "user",
          },
          {
            model: "address",
          },
        ],
      }

      get records_path, params: params, headers: json_headers
      expect(response.status).to be 200
      expect(json_body["users"].count).to eq(1)
      expect(json_body["addresses"].count).to eq(1)
    end

    context "there are multiple records with no primary key" do
      before(:each) do
        address
        second_address
      end

       it "can return multiple records" do
        params = {
          models: [
            {
              model: "address",
            },
          ],
        }

        get records_path, params: params, headers: json_headers
        expect(response.status).to be 200
        expect(json_body["addresses"].count).to eq(2)
      end

      it "returns the correct record" do
        params = {
          models: [
            {
              model: "address",