# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'qonsole_rails/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'qonsole_rails'
  spec.version     = QonsoleRails::VERSION
  spec.authors     = ['Epimorphics Ltd', 'Ian Dickinson']
  spec.email       = ['info@epimorphics.com']
  spec.homepage    = 'https://github.com/epimorphics/qonsole-rails'
  spec.summary     = 'SPARQL Qonsole engine for Rails'
  spec.description = 'Rails engine providing a dynamic console for editing and running SPARQL queries'
  spec.license     = 'Apache-2.0'

  # This gem will work with 3.3.5 or greater...
  spec.required_ruby_version = '~> 3.3'

  spec.files = Dir['{app,bin,config,lib,vendor}/**/*', 'LICENSE', 'Rakefile', 'README.rdoc']

  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'rails'

  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday-encoding'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'font-awesome-rails'
  spec.add_dependency 'haml-rails'
  spec.add_dependency 'jquery-datatables-rails'
  spec.add_dependency 'jquery-rails'
  spec.add_dependency 'lodash-rails'
  spec.add_dependency 'modulejs-rails'
  spec.add_dependency 'rubocop'
  spec.add_dependency 'rubocop-rails'
end
