# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.4.2] - 2026-02

- Adds instructions to the SPARQL editor and custom js so keyboard users can exit the textarea by pressing escape or shift + tab. [#102](https://github.com/epimorphics/qonsole-rails/issues/102)
- Increased contrast of Brackets inside the code editor. The query section now has labels and tweaked layour with scss [#112](https://github.com/epimorphics/qonsole-rails/issues/112)
- Increased text size of H2's and added H1 title "SPARQL Query Editor" for accessibility improvements [#111](https://github.com/epimorphics/qonsole-rails/issues/111)

## [2.4.1] - 2026-01

### Added

- Added code-coverage support using `simplecov` and a `coverage` Makefile
  target.

### Changed

- Bumped development and runtime dependencies for compatibility and stability
  (includes `rails`, `faraday` utilities, `byebug`, `solargraph`, `ruby-lsp`,
  `rbs`, `haml-rails`, and `jquery-datatables-rails`).
  [#108](https://github.com/epimorphics/qonsole-rails/issues/108)
- Migrated dependency declarations into `Gemfile` and modernised the gemspec.
- Unified project Makefiles and standardised `.gitignore` entries.
- Updated linting and developer tooling to align with the current toolchain.

### Fixed

- Handled nil result counts returned from SPARQL queries to avoid exceptions.
- Added handling for empty query results to improve user feedback.
- Corrected variable usage in an exception handler and reduced noisy test
  warnings.

## [2.4.0] - 2026-01

### Added

- Added handling for empty query results with user feedback to improve clarity.

### Changed

- Replaced sass-rails with dartsass-sprockets for Dart Sass 1.x support.
  [#105](https://github.com/epimorphics/qonsole-rails/issues/105)
- Refactored dropdown components to Bootstrap 5 with improved accessibility.
  [#105](https://github.com/epimorphics/qonsole-rails/issues/105)
- Enhanced query form layout with Bootstrap 5 utilities for better responsiveness.
  [#105](https://github.com/epimorphics/qonsole-rails/issues/105)
- Updated .gitignore to exclude macOS system files.
- Improved gemspec formatting for consistency.

### Fixed

- Configured response logging to debug mode only, reducing production noise.
- Fixed nil result count handling in SPARQL responses.
- Removed timezone deprecation warning in configuration to ensure clean boot.

## [2.3.0] - 2025-10

### Added

- Support for `ActionView::MissingTemplate` error handling now included
- Support for additional bad request error types (`Faraday::BadRequestError`,
  `ActionController::BadRequest`, `ActionController::ParameterMissing`) also
  included as well

### Changed

- `Rails` framework was upgraded from 8.0.2.1 to 8.1.1
- Error handling logic was refactored to use case statement for cleaner error
  grouping
- Dependency version constraints were relaxed from pessimistic (`~>`) to minimum
  version (`>=`) for broader compatibility
- `Faraday`, `haml-rails`, `faraday-follow_redirects`, and `faraday-retry` dependencies
  were updated to allow more flexible version ranges
- Development dependencies were updated including `rbs` (3.9.5), `rexml` (3.4.4),
  `solargraph` (0.57.0), and `rubocop`
- Locked dependency versions were bumped to latest compatible releases

### Fixed

- Faraday error objects are now raised correctly instead of passing string
  conversions to the caller
- Error handling and reporting was improved with better exception categorisation

## [2.2.1] - 2025-09

### Added

- Service-level tests were added for reliability and error handling

### Changed

- Client config was refactored to centralise timeouts and retries
- Version info stripping was improved, preserving line endings
- Dependencies were updated and patch version was incremented
- Maintenance comments for gem dependencies were clarified

## [2.2.0] - 2025-08

### Changed

- Core and secondary libraries were upgraded to latest patches
- Templating, XML, HTTP, and mail packages were refreshed
- Development tools and linting dependencies were updated
- Dependency versions were kept in sync across related projects
- Version cadence was aligned with current app suite

## [2.1.3] - 2025-07

### Added

- Styles to improve accessibility were added
  [#97](https://github.com/epimorphics/fsa-registry-config/issues/97)

## [2.1.2] - 2025-07

### Added

- Error handling for more specific exceptions was added
- Documentation was improved for better code understanding

### Changed

- Redundant URL conversion was removed for efficiency
- Retry logic was extracted into a reusable format
- Development tools were updated with new additions

## [2.1.1] - 2025-07

### Changed

- HTTP connections were refactored to use Faraday with retry options
- Dependencies were updated to compatible Faraday versions
- Maximum line length in code style configuration was increased
- Unnecessary disable comments were removed for improved lint adherence

## [2.1.0] - 2025-07

### Added

- Automation for local verification through GitHooks was added

### Changed

- `Rails` was updated to 8.0.2 and Ruby to 3.4.4
- Dependencies were upgraded to latest versions
- Query handling was enhanced with logging and error reporting
- Host validation and connection management were improved
- Validation was refactored and styles were normalised
- Configuration was updated; optional component was made adjustable
- Endpoint validation method was refactored for improved clarity
- System was configured to maintain full timezone offset

## [2.0.2] - 2025-04

### Added

- Built-in JavaScript `URL` and `URLSearchParams` for robust URL parameter
  parsing were added
- Conditional check to handle potential cross-origin blocking issues when
  retrieving queries from local storage while developing locally was added
- Frozen string literal comment was added to improve performance and memory
  usage

### Fixed

- More specific Faraday error handling in the SPARQL query service was
  implemented
- 404 errors were excluded from raising exceptions, and errors for
  `Faraday::ServerError` (5xx errors) were logged

## [2.0.1] - 2025-02

### Added

- Visual hints for dropdown selections were added
- `.mx-auto` class for centering elements was introduced
- Styling for `.prefix` to adjust padding and input margins was added
- Label styles within the `.prefix` class were updated
- Visually hidden text to indicate the currently selected endpoint was added
- Descriptions for each display format option in the dropdowns were included
- Accessibility was enhanced by providing context for users on what is currently
  selected

### Changed

- Gem dependencies and versions were updated
- `qonsole-rails` was renamed to `qonsole_rails`
- Several gems were upgraded including `faraday-multipart`, `net-imap`,
  `net-smtp`, `nio4r`, `parser`
- Copyright notice was updated to include current year

### Fixed

- Un-used modal attributes were adjusted
- Unnecessary aria-labelledby attribute was removed from the modal
- Button layout in vertical view was refactored
- Submit button was moved inside the label for better semantics
- Unnecessary HTML elements were cleaned up to simplify structure

## [2.0.0] - 2025-02

### Added

- Gem creation and publishing workflows for easier updates were added
- Pre-commit and pre-push githooks for linting/testing were implemented

### Changed

- Rubocop rules were updated for better readability and style
- Gemspec was adjusted to meet new guidelines from rubocop linting
- README was revamped with the latest info on the gem and publishing process
- Error handling for the qonsole gem was updated by ensuring that the proper
  error types are returned and handled accordingly
- Formatting for the error messages was updated to be more user-friendly
- Logging of errors was updated to improve the debugging process
- Tag helpers were updated to render the correct HTML tags for the query form
  elements

---

## 1.0.2 - 2024-11-01

- Fixed an issue with CSS for the checkboxes in the query form

## 1.0.1 - 2024-10-31

- Fixed an issue with CSS for the checkboxes in the query form

## 1.0.0 - 2024-10-23

- Upgraded rails to `7.2.1`
- Upgraded ruby to `3.3.5`
- Removed version locks from all gemspec dependencies
- Added latest version of the `codemirror` v3 package to `vendor/assets` and
  removed it from the gemspec

## 0.6.1 - 2020-08-27

- Dependency update to address CVE vulnerabilities

## 0.6.0 - 2020-02-10

- Fix for GH-14: add a Faraday middleware to ensure that the encoding header in
  the response is correctly reflected in the return body.

## 0.5.7 - 2019-12-16

- Fix a problem with displaying error pages, which are no longer assumed to be
  the in `public/landing` subfolder

## 0.5.6 - 2019-12-09

- dependency updates
- fix argument naming regression in `render_exception`

## 0.5.5 - 2019-10-09

- Updated gem dependencies, in particular to address CVE-2019-5477 The update to
  minitest suggested changes to prepare for minitest-6.0, in particular to wrap
  test expressions in `_(...)` before applying assertions like `must_be_nil`

## 0.5.4 - 2019-07-17

- Updated gem dependencies

## 0.5.0 - 2018-03-20

- Add a feature to the qonsole.json configuration file to allow service calls to
  be directed to an internal server. Spefically:

    "endpoints": { "default":
      "<http://landregistry.data.gov.uk/landregistry/query>", }, "alias": {
    "default": "<http://internal.alias.net/landregistry/query>", }

  will mean that queries are presented as going to the
  `landregistry.data.gov.uk` endpoint in the UI, but will actually be routed to
  the `internal.alias.net` server for execution.

- Add options param to allow QonsoleConfig.new() to override default
  configuration file name

## 0.4.0 - 2018-03-09

- Update the dependency for Haml-Rails to 1.0.0

## 0.3.5 - 2017-03-30

- Updated the `.rubocop.yml` config file, and resolved all outstanding Rubocop
  warnings

- Bump versions for dependent libraries
