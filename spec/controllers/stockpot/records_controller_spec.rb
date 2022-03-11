
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
              user_id: address.user_id,
            },
          ],
        }

        get records_path, params: params, headers: json_headers
        expect(response.status).to be 200
        expect(json_body["addresses"].count).to be(1)
        expect(json_body["addresses"][0]["city"]).to eq(address.city)
        expect(User.all.count).to be(2)
      end
    end

    it "returns the correct record" do
      user
      params = {
        models: [
          {
            model: "user",
            id: user.id,
          },
        ],
      }

      get records_path, params: params, headers: json_headers
      expect(response.status).to be 200
      expect(json_body["users"][0]["first_name"]).to eq(user.first_name)
      expect(json_body["users"][0]["last_name"]).to eq(user.last_name)
      expect(User.all.count).to be(1)
    end

    it "returns the correct namespaced records" do
      user_admin
      params = {
        models: [
          {
            model: "users/admin",
            id: user_admin.id,
          },
        ],
      }

      get records_path, params: params, headers: json_headers
      expect(response.status).to be 200
      expect(json_body["usersAdmins"][0]["is_admin"]).to eq(user_admin.is_admin)
      expect(Users::Admin.all.count).to be(1)
    end

    it "returns one record even if it is requested more than once" do
      user
      params = {
        models: [
          {
            model: "user",
            id: user.id,
          },
          {
            model: "user",
            id: user.id,
          },
        ],
      }

      get records_path, params: params, headers: json_headers
      expect(response.status).to be 200
      expect(json_body["users"].count).to eq(1)
      expect(json_body["users"][0]["first_name"]).to eq(user.first_name)
      expect(json_body["users"][0]["last_name"]).to eq(user.last_name)
    end
  end

  describe "DELETE #records" do
    it "requires a model to specified to delete a record" do
      delete records_path, params: {}.to_json, headers: json_headers
      check_error_response(response, expected)
    end

    it "deletes the record specified" do
      user
      params = {
        models: [
          {
            model: "user",
            id: user.id,
          },
        ],
      }.to_json

      expect(User.first).to eql(user)
      delete records_path, params: params, headers: json_headers
      expect(response.status).to be 202
      expect(User.all).to be_empty
    end

    it "deletes multiple records" do
      user
      second_user
      params = {
        models: [
          {
            model: "user",
          },
        ],
      }.to_json

      delete records_path, params: params, headers: json_headers
      expect(response.status).to be 202
      expect(User.all).to be_empty
    end

    it "rollsback transactions if something fails" do
      user
      user_admin
      params = {
        models: [
          {
            model: "user",
            id: user.id,
          },
          {
            model: "users/admin",
            id: user_admin.id,
          },
        ],
      }.to_json

      delete records_path, params: params, headers: json_headers
      expect(response.status).to be 400
      expect(User.all.count).to be(2)
      expect(Users::Admin.all.count).to be(1)
    end

    it "deletes models that are namespaced" do
      user_admin = FactoryBot.create(:users_admin, is_admin: false)
      params = {
        models: [
          {
            model: "users/admin",
            id: user_admin.id,
          },
        ],
      }.to_json

      delete records_path, params: params, headers: json_headers
      expect(response.status).to be 202
      expect(json_body["usersAdmins"][0]["is_admin"]).to eq(user_admin.is_admin)
      expect(Users::Admin.all.count).to be(0)
    end
  end

  describe "PUT #records" do
    it "requires a factory param to be specified to update" do
      put records_path, params: {}.to_json, headers: json_headers
      check_error_response(response, expected)
    end

    it "updates the specified record" do
      user
      updated_first_name = "updated_first_name"
      params = {
        models: [
          {
            model: "user",
            id: user.id,
            update: { first_name: updated_first_name },
          },
        ],
      }.to_json

      expect(User.last.first_name).to eql(user.first_name)
      put records_path, params: params, headers: json_headers
      expect(User.last.first_name).to eq(updated_first_name)
    end

    it "updates multiple records" do
      user
      second_user
      updated_first_name = "updated_first_name"
      params = {
        models: [
          {
            model: "user",
            update: { first_name: updated_first_name },
          },
        ],
      }.to_json

      put records_path, params: params, headers: json_headers
      expect(User.last.first_name).to eql(updated_first_name)
      expect(User.first.first_name).to eq(updated_first_name)
    end
