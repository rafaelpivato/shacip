# frozen_string_literal: true

require 'test_helper'

class RegistrationAdmissionTest < ActionDispatch::IntegrationTest
  test 'successful workflow' do
    # Starts registration by passing new user profile information
    create_params = { email: 'foobar@example.com', password: 'foobar' }
    post registrations_url, params: create_params
    assert_response :created
    registration_id = json_response.dig('data', 'id')
    assert_not_nil registration_id, 'Missing registration id'

    # What if we know user exist and don't want to accept registration?

    # At this moment, our client application sent a confirmation email to
    # the potential new user and back-end app will contact us with a
    # confirmation containing app domain just for reference
    update_params = { confirmed: 'test.example.com' }
    patch registration_url(registration_id), params: update_params
    assert_response :ok

    user_id = json_response.dig('data', 'user', 'id')
    assert_not_nil user_id, 'Missing user id from admission'

    # Load user information from users endpoint
    get user_url(user_id)
    assert_response :ok
    assert_equal 'foobar@example.com', json_response.dig('data', 'email')
  end
end
