# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('dummy/config/environment.rb', __dir__)

require 'simplecov'
SimpleCov.start do
  # Exclude test and config directories from coverage analysis
  add_filter '/test/'
  add_filter '/config/'
end

# Removed link to rails/test_help since it's causing an error initialising
# ActiveRecord, which we don't need. So I've just transcluded the contents
# of that file
# require "rails/test_help"

require 'active_support/test_case'
require 'action_controller'
require 'action_controller/test_case'
require 'action_dispatch/testing/integration'
require 'rails/generators/test_case'

require 'active_support/testing/autorun'

module ActionController
  class TestCase
    def before_setup # :nodoc:
      @routes = Rails.application.routes
      super
    end
  end
end

module ActionDispatch
  class IntegrationTest
    def before_setup # :nodoc:
      @routes = Rails.application.routes
      super
    end
  end
end

require 'minitest/autorun'
require 'byebug'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path('fixtures', __dir__)
end

# Helper class to include the Minitest spec DSL
class AcceptanceSpec < ActionDispatch::IntegrationTest
  extend Minitest::Spec::DSL
end
