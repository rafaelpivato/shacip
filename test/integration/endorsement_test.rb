# frozen_string_literal: true

require 'test_helper'

class EndorsementTest < ActionDispatch::IntegrationTest
  test 'bad user' do
    credentials = { email: 'foo@example.com', password: 'foobar' }
    post endorsements_url, params: credentials
    assert_response :created
    assert_equal 'unknown', json_response.dig('data', 'status')
    assert_nil json_response.dig('data', 'user')
  end

  test 'bad password' do
    user = users(:john)
    credentials = { email: user.email, password: 'foobar' }
    post endorsements_url, params: credentials
    assert_response :created
    assert_equal 'unknown', json_response.dig('data', 'status')
    assert_nil json_response.dig('data', 'user')
  end

  test 'no clue' do
    user = users(:john)
    user_cred = { email: 'foo@example.com', password: 'JOHN' }
    pass_cred = { email: user.email, password: 'foo' }
    post endorsements_url, params: user_cred
    bad_user = json_response
    post endorsements_url, params: pass_cred
    bad_pass = json_response
    assert_equal bad_user, bad_pass
  end

  test 'all good' do
    user = users(:john)
    credentials = { email: user.email, password: 'JOHN' }
    post endorsements_url, params: credentials
    assert_response :created
    assert_equal 'recognized', json_response.dig('data', 'status')
    assert_not_nil json_response.dig('data', 'user')
    assert_equal user.email, json_response.dig('data', 'user', 'email')
  end
end
