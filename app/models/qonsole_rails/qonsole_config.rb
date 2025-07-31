# frozen_string_literal: true

module QonsoleRails
  # Domain model to encapsulate a Qonsole configuration
  class QonsoleConfig
    CONFIG_DIR = 'config'
    DEFAULT_CONFIG_FILE = 'qonsole.json'
    DEFAULT_QUERY_TIMEOUT = 60

    attr_reader :config, :host

    # class instance variable to cache the configuration
    @static_config = nil

    def initialize(params, options = {})
      @config = qonsole_json(options).with_indifferent_access
      @host = options[:host]

      %w[q output url].each do |param|
        @config[param] = URI.decode_www_form_component(params[param]) if params.key?(param)
      end
    end

    def queries
      config[:queries]
    end

    def endpoints
      if Rails.env.development?
        dev_endpoint = { dev: 'https://hmlr-dev-pres.epimorphics.net/landregistry/query' }
        config[:endpoints].merge(dev_endpoint)
      else
        config[:endpoints]
      end
    end

    def prefixes
      config[:prefixes]
    end

    def query
      config[:q]
    end

    def output_format
      config[:output]
    end

    def default_endpoint
      endpoints[:default]
    end

    def given_endpoint
      config[:url]
    end

    def endpoint
      given_endpoint || default_endpoint
    end

    # Returns an absolute URL for the endpoint, using the host if provided
    # @param dest [String] the endpoint to convert to an absolute URL
    # @return [String] the absolute URL for the endpoint
    def absolute_endpoint(dest = endpoint)
      absolute_url(dest)
    end

    # The endpoint is valid if the dest is in the list of known endpoints
    # @param dest [String] the endpoint to check
    # @return [Boolean] true if the endpoint is valid, false otherwise
    def valid_endpoint?(dest = endpoint)
      known_endpoint?(dest)
    end

    # Check if the endpoint is known by comparing it to the list of known endpoints
    # @param url [String] the endpoint to check
    # @return [Boolean] true if the endpoint is known, false otherwise
    def known_endpoint?(url)
      endpoints.value?(url)
    end

    # The service destination defaults to the current endpoint,
    # but can be overridden via a service alias table
    def service_destination(dest = endpoint)
      return nil unless valid_endpoint?(dest)

      absolute_endpoint(alias_for(dest) || dest)
    end

    # Returns the SPARQL service options for the current configuration
    # @return [Hash] the options for the SPARQL service
    def sparql_service_options
      {
        output: output_format,
        query: query
      }
    end

    # Returns the query timeout from the configuration or a default value
    # @return [Integer] the query timeout in seconds
    def query_timeout
      config[:query_timeout] || DEFAULT_QUERY_TIMEOUT
    end

    private

    # Loads the qonsole configuration from a JSON file
    # @param options [Hash] options to customize the configuration loading
    # @option options [String] :config_file_name the name of the configuration file to load
    # @return [Hash] the parsed JSON configuration
    # @raise [RuntimeError] if the configuration file does not exist
    def qonsole_json(options)
      unless defined?(@qonsole_json)
        config_file_name = options[:config_file_name] || DEFAULT_CONFIG_FILE
        config = Rails.root.join(CONFIG_DIR, config_file_name)
        error = "Missing qonsole configuration file: config/#{config_file_name}"
        raise error unless File.exist?(config)

        # `File.read` is safer than `IO.read`. (convention:Security/IoMethods)
        @qonsole_json = JSON.parse(File.read(config))
      end

      @qonsole_json
    end

    # Returns an absolute URL for the given URL, using the host if provided
    # @param url [String] the URL to vaidate as an absolute URL
    # @return [String] the confirmed absolute URL
    def absolute_url(url)
      uri = URI.parse(url)
      uri.scheme ? url : "#{host}#{url}"
    end

    # Returns the alias for a given URL if it exists in the configuration
    # @param url [String] the URL to find the alias for
    # @return [String, nil] the alias for the URL or nil if not found
    def alias_for(url)
      # invert the endpoints hash to find the key for the URL
      key = endpoints.invert[url]
      # returns key if it exists in the config's alias section
      key && config[:alias] && config[:alias][key]
    end
  end
end
