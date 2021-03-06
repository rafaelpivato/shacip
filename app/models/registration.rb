# frozen_string_literal: true

##
# Represents an intention of an user to register against this system
#
class Registration < ApplicationRecord
  belongs_to :organization, optional: true
  belongs_to :user, optional: true

  def password=(value)
    self[:password_digest] = BCrypt::Password.create(value)
  end

  def user=
    raise InvalidOperation, 'Cannot assign user.'
  end

  def confirm!(stamp = 'confirmed')
    raise InvalidOperation if confirmed

    transaction do
      self[:confirmed] = stamp
      self[:status] = 'confirmed'
      self[:user_id] = create_or_get_user.id
      save!
      create_membership
    end
  end

  ##
  # Gets user JSON hash without password
  #
  def as_json(options = nil)
    options = options&.dup || {}
    options[:include] = %i[organization user]
    json = super(options)
    json.delete 'password'
    json.delete 'password_digest'
    json
  end

  private

  def user_params
    parsed = Rack::Utils.parse_nested_query(params)
    parsed['password_digest'] = password_digest
    ActionController::Parameters.new(parsed).permit(:name, :nickname)
  end

  def create_or_get_user
    params = { password_digest: password_digest }.merge!(user_params)
    User.create_with(params).find_or_create_by(email: email)
  end

  def create_membership
    if organization.nil?
      user.memberships.find_by(is_owner: true) ||
        Membership.new_organization(user)
    else
      Membership.add_user(organization, user)
    end
  end
end
