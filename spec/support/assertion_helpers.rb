
# frozen_string_literal: true

module AssertionHelpers
  def check_error_response(response, expected)
    parsed_body = JSON.parse(response.body)["error"]

    expect(response).to have_http_status(expected[:status])
    expected.with_indifferent_access.each_key do |prop|
      expectation_body = expected.with_indifferent_access

      expect(parsed_body[prop]).to eql expectation_body[prop]
    end
  end
end