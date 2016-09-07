$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem"s version:
require "qonsole_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "qonsole-rails"
  s.version     = QonsoleRails::VERSION
  s.authors     = ["Ian Dickinson"]
  s.email       = ["ian@epimorphics.com"]
  s.homepage    = "https://github.com/epimorphics/qonsole-rails"
  s.summary     = "SPARQL Qonsole engine for Rails"
  s.description = "A Rails engine that provides a dynamic console for editing and running SPARQL queries"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 5.0.0.1"

  s.add_dependency "jquery-rails", "~> 4.2.1"
  s.add_dependency "haml-rails", "~> 0.9.0"
  s.add_dependency "font-awesome-rails", "~> 4.6.3.0"
  s.add_dependency "modulejs-rails", "~> 1.9.0.1"
  s.add_dependency "lodash-rails", "~> 4.15.0"
  s.add_dependency "codemirror-rails", "~> 5.11"
  s.add_dependency "faraday", "~> 0.9.2"
  s.add_dependency "faraday_middleware", "~> 0.10.0"
  s.add_dependency "jquery-datatables-rails", "~> 3.4.0"

  s.add_development_dependency "minitest-spec-rails"
  s.add_development_dependency "minitest-rails"

end
