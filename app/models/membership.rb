# frozen_string_literal: true

##
# Defines a user membership relation with an organization
#
class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  def is_owner=(value)
    raise InvalidOperation, 'Use request_ownership!' unless id.nil?

    value = nil if value == false
    super(value)
  end

  def request_ownership!
    # rubocop:disable Rails/SkipsModelValidations
    Membership.where(organization: organization)
              .update_all("is_owner = (user_id == #{user_id})")
    # rubocop:enable Rails/SkipsModelValidations
    reload
  end

  def self.new_organization(user)
    user = User.create(user) if user.is_a? Hash
    organization = Organization.create(
      name: "#{user.display_name}'s Organization"
    )
    Membership.create user: user, organization: organization, is_owner: true
  end

  def self.add_user(organization, user)
    user = User.create(user) if user.is_a? Hash
    composite = { user: user, organization: organization }
    params = { is_owner: false }
    Membership.create_with(params).find_or_create_by(composite)
  end
end
