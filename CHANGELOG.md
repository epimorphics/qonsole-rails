# Change log for Qonsole Rails

Qonsole Rails is a Ruby-on-Rails engine for embedding the ability to display,
edit and run SPARQL queries in a larger Rails app.

## 2.1.0 - 2025-07

- Update Rails to 8.0.2 and Ruby to 3.4.4
- Upgrade dependencies to latest versions
- Enhance query handling with logging and error reporting
- Improve host validation and connection management
- Refactor validation and normalise styles
- Update configuration; make optional component adjustable
- Add automation for local verification through GitHooks
- Refactor endpoint validation method for improved clarity
- Configure system to maintain full timezone offset

## 2.0.2 - 2025-04

- feat: Now uses built-in JavaScript `URL` and `URLSearchParams` for robust URL
  parameter parsing
  - This ensures that the code can handle non-standard characters and encodings,
    improving compatibility with a wider range of URLs received
- feat: Added a conditional check to handle potential cross-origin blocking
  issues when retrieving queries from local storage while developing locally,
  now redirects developer back to the UKHPI instance with a confirmation prompt
  explaining as such
- fix: Implemented more specific Faraday error handling in the SPARQL query
  service
  - Now logs warnings for `Faraday::ClientError` (4xx errors), specifically
    excluding 404 errors from raising exceptions, and logs errors for
    `Faraday::ServerError` (5xx errors)
- fix: Added frozen string literal comment
  - Added a frozen string literal comment to the top of the
    `app/services/qonsole_rails/sparql_query_service.rb` file to improve
    performance and memory usage

## 2.0.1 - 2025-02

- fix: adjusted un-used modal attributes
  - Removed unnecessary aria-labelledby attribute from the modal.
- build: Update gem dependencies and versions
  - Renamed `qonsole-rails` to `qonsole_rails`
  - Updated `date` gem from 3.3.4 to 3.4.1
  - Upgraded several gems:
    - `faraday-multipart` from 1.0.4 to 1.1.0
    - `net-imap` from 0.4.17 to 0.5.5
    - `net-smtp` from 0.5.0 to 0.5.1
    - `nio4r` from 2.7.3 to 2.7.4
    - `parser` from 3.3.7.0 to 3.3.7.1
  - Updated other gems like `ffi`, `font-awesome-rails`, and more

- style: Add new styles for layout and prefix elements
  - Introduced a `.mx-auto` class for centering elements.
  - Added styling for `.prefix` to adjust padding and input margins.
  - Updated label styles within the `.prefix` class.
- fix: Refactor button layout in vertical view
  - Moved the submit button inside the label for better semantics.
  - Cleaned up unnecessary HTML elements to simplify structure.
- feat: Add visual hints for dropdown selections
  - Added visually hidden text to indicate the currently selected endpoint.
  - Included descriptions for each display format option in the dropdowns.
  - Enhanced accessibility by providing context for users on what is currently
    selected.
- refactor: Update copyright notice
  - Included current year in copyright statement.
  - Updated existing copyright text for clarity.

## 2.0.0 - 2025-02

- Added gem creation and publishing workflows for easier updates.
- Updated rubocop rules for better readability and style.
- Adjusted gemspec to meet new guidelines from rubocop linting.
- Implemented pre-commit and pre-push githooks for linting/testing.
- Revamped README with the latest info on the gem and publishing process.
- Updated the error handling for the qonsole gem by ensuring that the proper
  error types are returned and handled accordingly
- Updated the formatting for the error messages to be more user-friendly
- Updated the logging of errors to improve the debugging process
- Updated the tag helpers to render the correct HTML tags for the query form
  elements

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
