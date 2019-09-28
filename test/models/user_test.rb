# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:john)
  end

  test 'has email' do
    assert_respond_to @user, :email
  end

  test 'has name' do
    assert_respond_to @user, :name
  end

  test 'has nickname' do
    assert_respond_to @user, :nickname
  end

  test 'can assign but not get password' do
    assert_respond_to @user, :password=
    assert_not_respond_to @user, :password
  end

  test 'can validate password' do
    assert_respond_to @user, :validate_password
  end

  test 'no duplicate emails' do
    assert_raises ActiveRecord::RecordNotUnique do
      User.create email: @user.email
    end
  end

  test 'accepts duplicate names' do
    created = User.create email: 'foobar@example.com', name: @user.name
    assert_equal @user.name, created.name
  end

  test 'accepts duplicate nickname' do
    created = User.create email: 'foobar@example.com', nickname: @user.nickname
    assert_equal @user.nickname, created.nickname
  end

  test 'validates good password' do
    assert @user.validate_password(@user.nickname.upcase),
           'Valid password not accepted.'
  end

  test 'rejects bad bassword' do
    assert_not @user.validate_password(@user.nickname.downcase),
               'Invalid password not rejected.'
  end

  test 'dumps no password' do
    assert_not_includes @user.as_json, 'password_digest'
    assert_not_includes @user.as_json, 'password'
  end
end
