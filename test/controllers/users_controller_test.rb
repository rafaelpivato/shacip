# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
  end

  test 'should get index' do
    get users_url, as: :json
    assert_response :success
  end

  test 'should show user' do
    get user_url(@user), as: :json
    assert_response :success
  end

  test 'should not create user' do
    assert_raises ActionController::RoutingError do
      post users_url, params: { name: 'Foo Bar' }
    end
  end

  test 'should update user' do
    patch user_url(@user), params: { name: @user.name,
                                     nickname: @user.nickname }, as: :json
    assert_response 200
  end

  test 'should not destroy user' do
    assert_raises ActionController::RoutingError do
      delete user_url(@user), as: :json
    end
  end
end
