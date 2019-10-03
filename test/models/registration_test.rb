# frozen_string_literal: true

require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  def setup
    @registration = registrations(:clark)
  end

  test 'has email' do
    assert_respond_to @registration, :email
  end

  test 'has params' do
    assert_respond_to @registration, :params
  end

  test 'should not store name directly' do
    assert_not_respond_to @registration, :name
  end

  test 'should not store nickname directly' do
    assert_not_respond_to @registration, :nickname
  end

  test 'can assign but not get password' do
    assert_respond_to @registration, :password=
    assert_not_respond_to @registration, :password
  end

  test 'can access password_digest' do
    assert_respond_to @registration, :password_digest
  end

  test 'accept duplicate emails' do
    Registration.create email: @registration.email
    assert true
  rescue ActiveRecord::RecordNotUnique
    flunk 'Did not registered twice with same email.'
  end

  test 'accept emails for existing users' do
    Registration.create email: users(:john).email
    assert true
  rescue StandardError
    flunk 'Error creating registration for existing email.'
  end

  test 'confirm user for new organization' do
    registration = registrations(:arthur)
    membership = registration.confirm!
    assert_equal registration.email, membership.user.email
    user_organizations = membership.user.organizations.count
    assert_equal 1, user_organizations, 'Expected one organization.'
  end

  test 'confirm user for existing organization' do
    registration = registrations(:clark)
    assert_difference 'registration.organization.users.count' do
      membership = registration.confirm!
      assert_equal registration.email, membership.user.email
      user_organizations = membership.user.organizations.count
      assert_equal 1, user_organizations, 'Expected one organization.'
    end
  end

  test 'confirm existing email owning no organization for new organization' do
    registration = registrations(:peter)
    user = users(:peter)
    previous = user.memberships.first
    membership = registration.confirm!
    assert membership.is_owner, 'Existing user does not owns new organization.'
    assert_not previous.is_owner, 'Now owner for previous organization.'
    assert_equal registration.email, membership.user.email
  end

  test 'confirm existing email owning no organization for existing org' do
    registration = registrations(:jane)
    previous = memberships(:jane_does)
    membership = registration.confirm!
    assert_equal membership.organization, registration.organization
    assert_not membership.is_owner, 'User should not turn into new owner.'
    assert_not previous.is_owner, 'Now owner for previous organization.'
    assert_equal registration.email, membership.user.email
  end

  test 'confirm existing email owning one organization for new organization' do
    registration = registrations(:john_new)
    previous = memberships(:john_does)
    membership = registration.confirm!
    assert_equal previous, membership, 'Should reuse same owned organization.'
    assert membership.is_owner, 'Not owning original organization.'
    assert_equal registration.email, membership.user.email
  end

  test 'confirm existing email owning one organization for existing org' do
    registration = registrations(:john_existing)
    previous = memberships(:john_does)
    membership = registration.confirm!
    assert_equal registration.organization, membership.organization
    assert previous.is_owner, 'Not owning original organization.'
    assert_not membership.is_owner, 'Should not own added organization.'
    assert_equal registration.email, membership.user.email
  end

  test 'confirm existing email owning one organization for participating org' do
    registration = registrations(:john_participating)
    organization = organizations(:acme)
    assert_not_nil organization
    assert_no_difference 'organization.memberships.count' do
      membership = registration.confirm!
      assert_equal registration.organization, membership.organization
      assert_not membership.is_owner, 'Should not own participating org.'
      assert_equal registration.email, membership.user.email
    end
  end

  test 'confirm existing email owning one organization for owned org' do
    registration = registrations(:john_owned)
    organization = organizations(:does)
    assert_not_nil organization
    assert_no_difference 'organization.memberships.count' do
      membership = registration.confirm!
      assert_equal registration.organization, membership.organization
      assert membership.is_owner, 'Should keep owning organization.'
      assert_equal registration.email, membership.user.email
    end
  end
end
