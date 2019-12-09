# Change log for Qonsole Rails

Qonsole Rails is a Ruby-on-Rails engine for embedding the ability
to display, edit and run SPARQL queries in a larger Rails app.

## 0.5.6 - 2019-12-09

- dependency updates
- fix argument naming regression in `render_exception`

## 0.5.5 - 2019-10-09

- Updated gem dependencies, in particular to address CVE-2019-5477
  The update to minitest suggested changes to prepare for minitest-6.0,
  in particular to wrap test expressions in `_(...)` before applying
  assertions like `must_be_nil`

## 0.5.4 - 2019-07-17

- Updated gem dependencies

## 0.5.0 - 2018-03-20

- Add a feature to the qonsole.json configuration file to allow service calls
  to be directed to an internal server. Spefically:

    "endpoints": {
      "default": "http://landregistry.data.gov.uk/landregistry/query",
    },
    "alias": {
      "default": "http://internal.alias.net/landregistry/query",
    }

  will mean that queries are presented as going to the `landregistry.data.gov.uk`
  endpoint in the UI, but will actually be routed to the `internal.alias.net`
  server for execution.

- Add options param to allow QonsoleConfig.new() to override default
  configuration file name

## 0.4.0 - 2018-03-09

- Update the dependency for Haml-Rails to 1.0.0

## 0.3.5 - 2017-03-30

- Updated the `.rubocop.yml` config file, and resolved all
  outstanding Rubocop warnings

- Bump versions for dependent libraries
