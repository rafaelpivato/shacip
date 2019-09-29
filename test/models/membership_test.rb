# frozen_string_literal: true

require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  test 'new user and account' do
    profile = { email: 'foobar@example.com',
                name: 'Foo Bar',
                nickname: 'Foo' }
    membership = Membership.new_account(profile)
    assert_not_nil membership.user, 'Missing user.'
    assert_not_nil membership.account, 'Missing account.'
    assert membership.owner, 'First user should be owner.'
  end

  test 'new user existing account' do
    account = accounts(:does)
    profile = { email: 'foobar@example.com',
                name: 'Foo Bar',
                nickname: 'Foo' }
    membership = Membership.add_user account, profile
    assert_not_nil membership.user, 'Missing user.'
    assert_not_nil membership.account, 'Missing account.'
    assert_not membership.owner, 'Added user should not be owner.'
  end

  test 'existing user new account' do
    jane = users(:jane)
    assert_difference 'jane.accounts.count' do
      membership = Membership.new_account(jane)
      assert_not_nil membership.user, 'Missing user.'
      assert_not_nil membership.account, 'Missing account.'
      assert membership.owner, 'First user should be owner.'
    end
  end

  test 'existing user existing account' do
    account = accounts(:does)
    peter = users(:peter)
    membership = Membership.add_user account, peter
    assert_not_nil membership.user, 'Missing user.'
    assert_not_nil membership.account, 'Missing account.'
    assert_not membership.owner, 'Added user should not be owner.'
  end

  test 'get account owner' do
    account = accounts(:does)
    john = users(:john)
    owner = account.owner
    assert_equal john.email, owner.email
  end

  test 'cannot set owner as account attribute' do
    account = accounts(:does)
    jane = users(:jane)
    assert_raises MethodError do
      account.owner = jane
    end
  end

  test 'cannot set owner as membership attribute' do
    membership = memberships(:jane_does)
    assert_raises MethodError do
      membership.owner = true
    end
  end

  test 'change ownership' do
    jane_does = memberships(:jane_does)
    john_does = memberships(:john_does)
    assert john_does.owner, 'Assumption not satisfied.'
    assert_no_difference 'account.memberships.count' do
      jane_does.request_ownership!
    end
    assert jane_does, 'Request ownership failed.'
    john_does.reload
    jane_does.reload
    assert_not john_does.owner, 'Still owner.'
    assert jane_does.owner, 'Not owner after reload.'
  end
end
