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
  spec.required_ruby_version = '~> 3.4'

  spec.files = Dir['{app,bin,config,lib,vendor}/**/*', 'LICENSE', 'Rakefile', 'README.rdoc']

  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'rails', '~> 8.0'

  # * Resolves `WARNING:  open-ended dependency on rails (>= 0) is not recommended use a bounded requirement`
  # Farad
  spec.add_dependency 'faraday', '~> 2.13'
  spec.add_dependency 'faraday-encoding', '~> 0.0.6'
  spec.add_dependency 'faraday-follow_redirects', '~> 0.3.0'
  spec.add_dependency 'faraday-retry', '~> 2.0'
  spec.add_dependency 'font-awesome-rails', '~> 4.7.0'
  spec.add_dependency 'haml-rails', '~> 2.1'
  spec.add_dependency 'jquery-datatables-rails', '~> 3.4'
  spec.add_dependency 'jquery-rails', '~> 4.6'
  spec.add_dependency 'lodash-rails', '~> 4.17'
  spec.add_dependency 'modulejs-rails', '~> 2.2.0'
  spec.add_dependency 'rubocop', '~> 1.78'
  spec.add_dependency 'rubocop-ast', '~> 1.46'
  spec.add_dependency 'rubocop-rails', '~> 2.16'
end
