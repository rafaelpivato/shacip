# frozen_string_literal: true

##
# Users registered in this system
#
class User < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships

  def display_name
    name || nickname || Mail::Address.new(email).local
  end

  def password=(value)
    self.password_digest = BCrypt::Password.create(value)
  end

  ##
  # Validates user password against given challenge
  #
  def validate_password(challenge)
    actual = BCrypt::Password.new(password_digest)
    actual == challenge
  end

  ##
  # Gets user JSON hash without password
  #
  def as_json(options = nil)
    json = super(options)
    json.delete 'password'
    json.delete 'password_digest'
    json
  end
end
