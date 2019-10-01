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

  test 'confirm user for new account' do
    registration = registrations(:arthur)
    membership = registration.confirm!
    assert_equal registration.email, membership.user.email
    user_accounts = membership.user.accounts.count
    assert_equal 1, user_accounts, 'Expected new user to have one account.'
  end

  test 'confirm user for existing account' do
    registration = registrations(:clark)
    assert_difference 'registration.account.users.count' do
      membership = registration.confirm!
      assert_equal registration.email, membership.user.email
      user_accounts = membership.user.accounts.count
      assert_equal 1, user_accounts, 'Expected new user to have one account.'
    end
  end

  test 'confirm existing email owning no account for new account' do
    registration = registrations(:peter)
    user = users(:peter)
    previous = user.memberships.first
    membership = registration.confirm!
    assert membership.is_owner, 'Existing user does not owns new account.'
    assert_not previous.is_owner, 'Now owner for previous account.'
    assert_equal registration.email, membership.user.email
  end

  test 'confirm existing email owning no account for existing account' do
    registration = registrations(:jane)
    previous = memberships(:jane_does)
    membership = registration.confirm!
    assert_equal membership.account, registration.account, 'Wrong account.'
    assert_not membership.is_owner, 'User should not turn into new owner.'
    assert_not previous.is_owner, 'Now owner for previous account.'
    assert_equal registration.email, membership.user.email
  end

  test 'confirm existing email owning one account for new account' do
    registration = registrations(:john_new)
    previous = memberships(:john_does)
    membership = registration.confirm!
    assert_equal previous, membership, 'Should reuse same owned account.'
    assert membership.is_owner, 'Not owning original account.'
    assert_equal registration.email, membership.user.email
  end

  test 'confirm existing email owning one account for existing account' do
    registration = registrations(:john_existing)
    previous = memberships(:john_does)
    membership = registration.confirm!
    assert_equal registration.account, membership.account, 'Used another.'
    assert previous.is_owner, 'Not owning original account.'
    assert_not membership.is_owner, 'Should not own added account.'
    assert_equal registration.email, membership.user.email
  end

  test 'confirm existing email owning one account for participating account' do
    registration = registrations(:john_participating)
    account = accounts(:acme)
    assert_not_nil account
    assert_no_difference 'account.memberships.count' do
      membership = registration.confirm!
      assert_equal registration.account, membership.account, 'Used another'
      assert_not membership.is_owner, 'Should not own participating account.'
      assert_equal registration.email, membership.user.email
    end
  end

  test 'confirm existing email owning one account for owned account' do
    registration = registrations(:john_owned)
    account = accounts(:does)
    assert_not_nil account
    assert_no_difference 'account.memberships.count' do
      membership = registration.confirm!
      assert_equal registration.account, membership.account, 'Used another'
      assert membership.is_owner, 'Should keep owning account.'
      assert_equal registration.email, membership.user.email
    end
  end
end
