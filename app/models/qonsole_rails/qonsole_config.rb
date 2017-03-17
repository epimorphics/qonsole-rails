module QonsoleRails
  # Domain model to encapsulate a Qonsole configuration
  class QonsoleConfig
    CONFIG_DIR = "config".freeze
    DEFAULT_CONFIG_FILE = "qonsole.json".freeze
    DEFAULT_QUERY_TIMEOUT = 60

    attr_reader :config, :host

    def initialize(params, host = nil)
      @config = qonsole_json.with_indifferent_access
      @config['q'] = URI.unescape(params['q']) if params['q']
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

    private

    def qonsole_json(config_file_name = DEFAULT_CONFIG_FILE)
      unless defined? @@static_config
        config = File.join(Rails.root, CONFIG_DIR, config_file_name)
        raise "Missing qonsole configuration file config/#{config_file_name}" unless File.exist?(config)

        @@static_config = JSON.parse(IO.read(config))
      end

      @@static_config
    end

    def absolute_url(url)
      url.start_with?("http:") ? url : "#{host}#{url}"
    end
  end
end
