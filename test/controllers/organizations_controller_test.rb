# frozen_string_literal: true

require 'test_helper'

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:does)
  end

  test 'should get index' do
    get organizations_url, as: :json
    assert_response :success
  end

  test 'should not create organization' do
    assert_raises ActionController::RoutingError do
      post organizations_url, params: { name: @organization.name }, as: :json
    end
  end

  test 'should show organization' do
    get organization_url(@organization), as: :json
    assert_response :success
  end

  test 'should update organization' do
    patch organization_url(@organization),
          params: { name: @organization.name },
          as: :json
    assert_response :ok
  end

  test 'should not destroy organization' do
    assert_raises ActionController::RoutingError do
      delete organization_url(@organization), as: :json
    end
  end
end
