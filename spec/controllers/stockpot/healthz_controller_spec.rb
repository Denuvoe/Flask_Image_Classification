# frozen_string_literal: true

RSpec.describe Stockpot::HealthzController, type: :request do
  describe "GET #index" do
    it "returns successfully if the route i