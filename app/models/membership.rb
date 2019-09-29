# frozen_string_literal: true

##
# Defines a user membership relation with an account
#
class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :account
end
