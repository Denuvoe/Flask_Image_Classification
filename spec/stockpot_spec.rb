# frozen_string_literal: true

RSpec.describe Stockpot do
  it "has a version number" do
    expect(described_class::VERSION).to be_a String
    expect(described_class::VERSION).not_to be_blank
  end
end
