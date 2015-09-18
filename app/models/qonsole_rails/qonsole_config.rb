module QonsoleRails
  class QonsoleConfig
    CONFIG_DIR = "config"
    DEFAULT_CONFIG_FILE = "qonsole.json"
    DEFAULT_QUERY_TIMEOUT = 60

    attr_reader :config, :host

    def initialize( params, host = nil  )
      @config = qonsole_json.merge( params ).with_indifferent_access
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
      config[:url] || default_endpoint
    end

    def endpoint
      absolute_url( given_endpoint )
    end

    def valid_endpoint?
      known_endpoint?( given_endpoint )
    end

    def known_endpoint?( url )
      endpoints.has_value?( url )
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

    :private

    def qonsole_json( config_file_name = DEFAULT_CONFIG_FILE )
      unless defined? @@static_config
        config = File.join( Rails.root, CONFIG_DIR, config_file_name )
        raise "Missing qonsole configuration file config/#{config_file_name}" unless File.exist?( config )

        @@static_config = JSON.parse( IO.read( config ) )
      end

      @@static_config
    end

    def absolute_url( url )
      url.start_with?( "http:" ) ? url : "#{host}#{url}"
    end

  end
end
