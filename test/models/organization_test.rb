# frozen_string_literal: true

require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  def setup
    @organization = organizations(:does)
  end

  test 'has name' do
    assert_respond_to @organization, :name
  end

  test 'has number' do
    assert_respond_to @organization, :number
  end

  test 'can change name' do
    @organization.name = 'Foo Bar'
    assert_equal 'Foo Bar', @organization.name
  end

  test 'accepts duplicate names' do
    created = Organization.create name: @organization.name
    assert_equal @organization.name, created.name
  end

  test 'no duplicate numbers' do
    assert_raises ActiveRecord::RecordNotUnique do
      Organization.create name: 'Foo Bar', number: @organization.number
    end
  end

  test 'assign default new number' do
    organization = Organization.new(name: 'Foo Bar')
    organization.save
    assert_not_nil organization.number
    assert_not_empty organization.number
  end

  test 'default new number on create' do
    organization = Organization.create(name: 'Foo Bar')
    assert_not_nil organization.number
    assert_not_empty organization.number
  end

  test 'assign default number if assigning nil' do
    @organization.number = nil
    @organization.save
    assert_not_nil @organization.number
    assert_not_empty @organization.number
  end

  test 'strip number on assign' do
    @organization.number = ' foobar '
    assert_equal 'foobar', @organization.number
  end
end
