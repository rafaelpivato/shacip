# frozen_string_literal: true

##
# Error thrown when an invalid operation happens in code
#
class InvalidOperation < ApplicationError
  def initialize(msg = 'Invalid operation')
    super
  end
end
