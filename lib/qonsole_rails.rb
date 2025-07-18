# frozen_string_literal: true

# Load the Rails engine
require 'qonsole_rails/engine'

# We do load the gem dependencies here because this is a gem, not a bundle per-se
require 'rails'
require 'faraday'
require 'faraday/encoding'
require 'faraday/follow_redirects'
require 'faraday/retry'
require 'font-awesome-rails'
require 'haml-rails'
require 'jquery-datatables-rails'
require 'jquery-rails'
require 'lodash-rails'
require 'modulejs-rails'

# :nodoc:
module QonsoleRails
end
