# Change log for Qonsole Rails

Qonsole Rails is a Ruby-on-Rails engine for embedding the ability
to display, edit and run SPARQL queries in a larger Rails app.

## 0.5.0 - 2018-03-20

* Add a feature to the qonsole.json configuration file to allow service calls
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

* Add options param to allow QonsoleConfig.new() to override default
  configuration file name

## 0.4.0 - 2018-03-09

* Update the dependency for Haml-Rails to 1.0.0

## 0.3.5 - 2017-03-30

* Updated the `.rubocop.yml` config file, and resolved all
  outstanding Rubocop warnings

* Bump versions for dependent libraries
