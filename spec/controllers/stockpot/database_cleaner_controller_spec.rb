
# frozen_string_literal: true

RSpec.describe Stockpot::DatabaseCleanerController, type: :request do
  let(:body) { { status: 204 }.to_json }
