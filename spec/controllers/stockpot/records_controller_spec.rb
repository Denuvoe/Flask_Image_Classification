
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