# frozen_string_literal: true

source 'https://rubygems.org'

# Declare your gem's information in qonsole_rails.gemspec.
# Moved call to the end of this file to pass on the dependencies we do not
# control that are loaded from GitHub
# gemspec

# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.

group :maintenance do
  # Runtime dependencies for this gem (as declared in the gemspec) are included
  # in this group to allow bundler to validate when running the `bundle outdated
  # --only-explicit` from the `make update` target.

  # Versions should be kept in sync with those in the .gemspec
  gem 'faraday', '~> 2.13'
  gem 'faraday-encoding', '~> 0.0', '>= 0.0.6'
  gem 'faraday-follow_redirects', '~> 0.3', '>= 0.3.0'
  gem 'faraday-retry', '~> 2.0'
  gem 'rails', '~> 8.0'

  gem 'font-awesome-rails', '~> 4.7.0'
  gem 'haml-rails', '~> 3.0'
  gem 'jquery-rails', '~> 4.6'
  gem 'lodash-rails', '~> 4.17'
  gem 'modulejs-rails', '~> 2.2.0'
end

# This gem depends on a forked version of jquery-datatables-rails to include a
# fix that has not yet been merged into the main repo. See:
# https://stackoverflow.com/a/68001592/5760177
gem 'jquery-datatables-rails', '~> 3.5.0',
    git: 'git@github.com:marlinpierce/jquery-datatables-rails',
    branch: 'master-3.5'

# Declare any dependencies that are used in development here instead of in your
# gemspec. These might include edge Rails or gems from your path or Git.
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :test do
  gem 'minitest-rails'
  gem 'minitest-spec-rails'
  gem 'simplecov', require: false
end

group :development do
  gem 'rubocop'
  gem 'rubocop-rails', require: false

  gem 'ruby-lsp', require: false
  gem 'solargraph', require: false
end

# Moved call here to pass on the dependencies we do not control to the gemspec
gemspec
