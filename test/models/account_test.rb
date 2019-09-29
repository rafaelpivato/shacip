# frozen_string_literal: true

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def setup
    @account = accounts(:does)
  end

  test 'has name' do
    assert_respond_to @account, :name
  end

  test 'has number' do
    assert_respond_to @account, :number
  end

  test 'can change name' do
    @account.name = 'Foo Bar'
    assert_equal 'Foo Bar', @account.name
  end

  test 'accepts duplicate names' do
    created = Account.create name: @account.name
    assert_equal @account.name, created.name
  end

  test 'no duplicate numbers' do
    assert_raises ActiveRecord::RecordNotUnique do
      Account.create name: 'Foo Bar', number: @account.number
    end
  end

  test 'assign default new number' do
    account = Account.new(name: 'Foo Bar')
    account.save
    assert_not_nil account.number
    assert_not_empty account.number
  end

  test 'assign default number if assigning nil' do
    @account.number = nil
    @account.save
    assert_not_nil @account.number
    assert_not_empty @account.number
  end

  test 'strip number on assign' do
    @account.number = ' foobar '
    assert_equal 'foobar', @account.number
  end
end
