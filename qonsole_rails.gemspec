$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
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

  s.add_dependency "rails", "~> 4.0.2"

  s.add_dependency "haml"
  s.add_dependency "fontawesome-rails"
end
