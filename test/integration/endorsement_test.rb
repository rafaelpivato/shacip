# frozen_string_literal: true

require 'test_helper'

class EndorsementTest < ActionDispatch::IntegrationTest
  test 'wrong method' do
    get endorsement_url
    assert_response :method_not_allowed
  end

  test 'bad payload' do
    post endorsement_url, params: { foobar: 'quxbaz' }
    assert_response :bad_request
  end

  test 'bad user' do
    credentials = { email: 'foo@example.com', password: 'foobar' }
    post endorsement_url, params: { credentials: credentials }
    assert_response :created
    assert_json 'status', 'rejected'
    assert_json 'user', nil
  end

  test 'bad password' do
    user = users(:john)
    credentials = { email: user.email, password: 'foobar' }
    post @endorsement_url, params: { credentials: credentials }
    assert_response :created
    assert_json 'status', 'rejected'
    assert_json 'user', nil
  end

  test 'no clue' do
    user = users(:john)
    user_cred = { email: 'foo@example.com', password: 'john' }
    pass_cred = { email: user.email, password: 'foo' }
    post endorsement_url, params: { credentials: user_cred }
    bad_user = json_response
    post endorsement_url, params: { credentials: pass_cred }
    bad_pass = json_response
    assert_equal bad_user, bad_pass
  end

  test 'all good' do
    user = users(:john)
    credentials = { email: user.email, password: 'john' }
    post endorsement_url, params: { credentials: credentials }
    assert_response :created
    assert_json 'status', 'accepted'
    assert_json 'user.email', user.email
  end
end
