# frozen_string_literal: true

##
# Defines a user membership relation with an account
#
class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :account

  def is_owner=(value)
    raise InvalidOperation, 'Use request_ownership!' unless id.nil?

    super(value)
  end

  def request_ownership!
    # rubocop:disable Rails/SkipsModelValidations
    Membership.where(account: account)
              .update_all("is_owner = (user_id == #{user_id})")
    # rubocop:enable Rails/SkipsModelValidations
    reload
  end

  def self.new_account(user)
    user = User.create(user) if user.is_a? Hash
    account = Account.create(name: "#{user.display_name}'s Account")
    Membership.create user: user, account: account, is_owner: true
  end

  def self.add_user(account, user)
    user = User.create(user) if user.is_a? Hash
    Membership.create user: user, account: account, is_owner: false
  end
end
