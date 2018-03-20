module QonsoleRails
  # Domain model to encapsulate a Qonsole configuration
  class QonsoleConfig
    CONFIG_DIR = 'config'.freeze
    DEFAULT_CONFIG_FILE = 'qonsole.json'.freeze
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
      config[:endpoints]
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

    def absolute_endpoint(dest = endpoint)
      absolute_url(dest)
    end

    def valid_endpoint?(dest = endpoint)
      known_endpoint?(dest)
    end

    # The service destination defaults to the current endpoint, but can be overridden
    # via a service alias table
    def service_destination(dest = endpoint)
      abs_dest = absolute_endpoint(dest)
      return nil unless valid_endpoint?(abs_dest)
      alias_for(abs_dest) || abs_dest
    end

    def known_endpoint?(url)
      endpoints.value?(url)
    end

    def sparql_service_options
      {
        output: output_format,
        query: query
      }
    end

    def query_timeout
      config[:query_timeout] || DEFAULT_QUERY_TIMEOUT
    end

    private

    def qonsole_json(options)
      unless defined?(@qonsole_json)
        config_file_name = options[:config_file_name] || DEFAULT_CONFIG_FILE
        config = Rails.root.join(CONFIG_DIR, config_file_name)
        error = "Missing qonsole configuration file: config/#{config_file_name}"
        raise error unless File.exist?(config)

        @qonsole_json = JSON.parse(IO.read(config))
      end

      @qonsole_json
    end

    def absolute_url(url)
      url.start_with?('http:') ? url : "#{host}#{url}"
    end

    def alias_for(url)
      key = endpoints.invert[url]
      key && config[:alias] && config[:alias][key]
    end
  end
end
