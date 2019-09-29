# frozen_string_literal: true

##
# Base class for all errors raised by this application
#
class ApplicationError < StandardError
  def initialize(msg = 'PoC Auth Service error')
    super
  end
end
