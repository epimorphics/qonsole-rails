module QonsoleRails
  class QonsoleConfig
    attr_reader :given_query, :given_endpoint

    def initialize( params, config_file_name = 'qonsole.json' )
      config = File.join( Rails.root, 'config', 'qonsole.json' )
      raise "Missing qonsole configuration file config/#{config_file_name}" unless File.exist?( config )

      @config = JSON.parse( IO.read( config ) ).with_indifferent_access

      @given_query = params[:query]
      @given_endpoint = params[:sapi]
    end

    def queries
      @config[:queries]
    end

    def endpoints
      @config[:endpoints]
    end

    def prefixes
      @config[:prefixes]
    end

    def default_endpoint
      given_endpoint || endpoints[:default]
    end
  end
end
