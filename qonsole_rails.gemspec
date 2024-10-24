# frozen-string-literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'qonsole_rails/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'qonsole-rails'
  s.version     = QonsoleRails::VERSION
  s.authors     = ['Ian Dickinson']
  s.email       = ['ian.dickinson@epimorphics.com']
  s.homepage    = 'https://github.com/epimorphics/qonsole-rails'
  s.summary     = 'SPARQL Qonsole engine for Rails'
  s.description = 'Rails engine providing a dynamic console for editing and running SPARQL queries'

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails'

  s.add_dependency 'faraday'
  s.add_dependency 'faraday-encoding'
  s.add_dependency 'faraday_middleware'
  s.add_dependency 'font-awesome-rails'
  s.add_dependency 'haml-rails'
  s.add_dependency 'jquery-datatables-rails'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'lodash-rails'
  s.add_dependency 'modulejs-rails'

  s.add_development_dependency 'byebug'
  s.add_development_dependency 'minitest-rails'
  s.add_development_dependency 'minitest-spec-rails'
end
