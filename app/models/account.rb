# frozen_string_literal: true

##
# Accounts to be managed or accessed by users
#
# Accounts will have their unique numbers created using HashIds or NanoId
# with a short alphabet like 'AEFHJLPRSTXY34569'.
#
class Account < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  before_validation do |account|
    account.number ||= random_number
  end

  def owner
    memberships.find_by(is_owner: true).user
  end

  def number=(value)
    super(value&.strip)
  end

  def random_number
    Nanoid.generate(size: 22, alphabet: 'AEFHJLPRSTXY34569')
  end
end
