# frozen_string_literal: true

RSpec.describe Stockpot::HealthzController, type: :request do
  describe "GET #index" do
    it "returns successfully if the route is available" do
      get healthz_path

      expect(response.code).to eql "200"
    end
  end
end
