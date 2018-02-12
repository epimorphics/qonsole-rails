module QonsoleRails
  # Domain model to encapsulate a Qonsole configuration
  class QonsoleConfig
    CONFIG_DIR = 'config'.freeze
    DEFAULT_CONFIG_FILE = 'qonsole.json'.freeze
    DEFAULT_QUERY_TIMEOUT = 60

    attr_reader :config, :host

    # class instance variable to cache the configuration
    @static_config = nil

    def initialize(params, host = nil)
      @config = qonsole_json.with_indifferent_access
      @config['q'] = URI.decode_www_form_component(params['q']) if params.key?('q')
      @config['output'] = params['output'] if params.key?('output')
      @config['url'] = params['url'] if params.key?('url')
      @host = host
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

    def absolute_endpoint
      absolute_url(endpoint)
    end

    def valid_endpoint?
      known_endpoint?(endpoint)
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

    def self.static_config
      @static_config
    end

    def self.static_config=(config)
      @static_config = config
    end

    private

    def qonsole_json(config_file_name = DEFAULT_CONFIG_FILE)
      unless self.class.static_config
        config = Rails.root.join(CONFIG_DIR, config_file_name)
        error = "Missing qonsole configuration file config/#{config_file_name}"
        raise error unless File.exist?(config)

        self.class.static_config = JSON.parse(IO.read(config))
      end

      self.class.static_config
    end

    def absolute_url(url)
      url.start_with?('http:') ? url : "#{host}#{url}"
    end
  end
end
