# frozen_string_literal: true

require 'minitest/reporters'

reporters = if ENV.fetch('CI', 'false') == 'true'
              [Minitest::Reporters::SpecReporter.new,
               Minitest::Reporters::JUnitReporter.new]
            else
              [Minitest::Reporters::DefaultReporter.new]
            end
Minitest::Reporters.use! reporters

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def json_response
    JSON.parse(response.body)
  end
end
