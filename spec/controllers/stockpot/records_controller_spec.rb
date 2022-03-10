
# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stockpot::RecordsController, type: :request do
  let(:json_headers) { { "CONTENT_TYPE": "application/json" } }