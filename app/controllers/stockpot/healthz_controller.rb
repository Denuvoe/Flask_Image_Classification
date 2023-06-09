# frozen_string_literal: true

module Stockpot
  class HealthzController < MainController
    def index
      render json: { "message": "success" }, status: :ok
    end
  end
end
