# frozen_string_literal: true

require 'test_helper'

class RegistrationAdmissionTest < ActionDispatch::IntegrationTest
  test 'successful workflow' do
    # Starts registration by passing new user profile information
    profile = { email: 'foobar@example.com', password: 'foobar',
                name: 'Foo Bar', nickname: 'Foo' }
    post registrations_url, params: profile
    assert_response :created
    registration_token = json_response.dig(:token)
    assert_not_nil registration_token, 'Missing registration token.'

    # What if we know user exist and don't want to accept registration?

    # At this moment, our client application sent a confirmation email to
    # the potential new user with the token created at registration above
    post admissions_url, params: { token: registration_token }
    assert_response :created
    user_id = json_response.dig(:user_id)
    assert_not_nil user_id, 'Missing user id from admission.'

    # What if the token is invalid?

    # Load user information from users endpoint
    get users_url(user_id)
    assert_response :ok
    assert_equal 'foobar@example.com', json_response.dig(:email)
  end
end
