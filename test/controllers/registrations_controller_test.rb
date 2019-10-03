# frozen_string_literal: true

require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @registration = registrations(:clark)
  end

  test 'should get index' do
    get registrations_url, as: :json
    assert_response :success
  end

  test 'should create simple registration' do
    params = {
      email: 'foobar@example.com',
      password: 'foobar'
    }
    assert_difference('Registration.count') do
      post registrations_url, params: params, as: :json
    end

    assert_response 201
  end

  test 'should create registration with params' do
    params = {
      email: 'foobar@example.com',
      password: 'foobar',
      params: {
        name: 'Foo Bar',
        nickname: 'Foo',
        quxbaz: 'Bar Foo'
      }.to_param
    }
    assert_difference('Registration.count') do
      post registrations_url, params: params, as: :json
    end

    assert_response 201
  end

  test 'should create registration against existing organization' do
    params = {
      organization: organizations(:acme).id,
      email: 'foobar@example.com',
      password: 'foobar'
    }
    assert_difference('Registration.count') do
      post registrations_url, params: params, as: :json
    end

    assert_response 201
  end

  test 'should show registration' do
    get registration_url(@registration), as: :json
    assert_response :success
  end

  test 'should confirm registration' do
    params = {
      confirmed: 'myapp.example.com'
    }
    patch registration_url(@registration), params: params, as: :json
    assert_response 200
  end

  test 'should destroy registration' do
    assert_difference('Registration.count', -1) do
      delete registration_url(@registration), as: :json
    end

    assert_response 204
  end
end
