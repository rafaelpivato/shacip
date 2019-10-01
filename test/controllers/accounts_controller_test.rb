# frozen_string_literal: true

require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:does)
  end

  test 'should get index' do
    get accounts_url, as: :json
    assert_response :success
  end

  test 'should not create account' do
    assert_raises ActionController::RoutingError do
      post accounts_url, params: { name: @account.name }, as: :json
    end
  end

  test 'should show account' do
    get account_url(@account), as: :json
    assert_response :success
  end

  test 'should update account' do
    patch account_url(@account), params: { name: @account.name }, as: :json
    assert_response :ok
  end

  test 'should not destroy account' do
    assert_raises ActionController::RoutingError do
      delete account_url(@account), as: :json
    end
  end
end
