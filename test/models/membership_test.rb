# frozen_string_literal: true

require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  test 'new user and organization' do
    profile = { email: 'foobar@example.com',
                name: 'Foo Bar',
                nickname: 'Foo' }
    membership = Membership.new_organization(profile)
    assert_not_nil membership.user, 'Missing user.'
    assert_not_nil membership.organization, 'Missing organization.'
    assert membership.is_owner, 'First user should be owner.'
  end

  test 'new user existing organization' do
    organization = organizations(:does)
    profile = { email: 'foobar@example.com',
                name: 'Foo Bar',
                nickname: 'Foo' }
    membership = Membership.add_user organization, profile
    assert_not_nil membership.user, 'Missing user.'
    assert_not_nil membership.organization, 'Missing organization.'
    assert_not membership.is_owner, 'Added user should not be owner.'
  end

  test 'existing user new organization' do
    jane = users(:jane)
    assert_difference 'jane.organizations.count' do
      membership = Membership.new_organization(jane)
      assert_not_nil membership.user, 'Missing user.'
      assert_not_nil membership.organization, 'Missing organization.'
      assert membership.is_owner, 'First user should be owner.'
    end
  end

  test 'existing user existing organization' do
    organization = organizations(:does)
    peter = users(:peter)
    membership = Membership.add_user organization, peter
    assert_not_nil membership.user, 'Missing user.'
    assert_not_nil membership.organization, 'Missing organization.'
    assert_not membership.is_owner, 'Added user should not be owner.'
  end

  test 'get organization owner' do
    organization = organizations(:does)
    john = users(:john)
    owner = organization.owner
    assert_equal john.email, owner.email
  end

  test 'cannot set owner as organization attribute' do
    organization = organizations(:does)
    jane = users(:jane)
    assert_raises NoMethodError do
      organization.owner = jane
    end
  end

  test 'cannot set owner as membership attribute' do
    membership = memberships(:jane_does)
    assert_raises InvalidOperation do
      membership.is_owner = true
    end
  end

  test 'change ownership' do
    organization = organizations(:does)
    assert_not_nil organization
    jane_does = memberships(:jane_does)
    john_does = memberships(:john_does)
    assert john_does.is_owner, 'Assumption not satisfied.'
    assert_no_difference 'organization.memberships.count' do
      jane_does.request_ownership!
    end
    assert jane_does.is_owner, 'Request ownership failed.'
    john_does.reload
    jane_does.reload
    assert_not john_does.is_owner, 'Still owner after reload.'
    assert jane_does.is_owner, 'Not owner after reload.'
  end
end
