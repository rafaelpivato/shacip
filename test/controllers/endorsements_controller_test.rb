# frozen_string_literal: true

require 'test_helper'

class EndorsementsControllerTest < ActionDispatch::IntegrationTest
  test 'should create valid endorsement' do
    user = users(:john)
    credentials = { email: user.email, password: user.nickname.upcase }
    post endorsements_url, params: credentials
    assert_response :success
  end
end
