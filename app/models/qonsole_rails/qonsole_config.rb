module QonsoleRails
  class QonsoleConfig
    def initialize( config_file_name = 'qonsole.json' )
      config = File.join( Rails.root, 'config', 'qonsole.json' )
      raise "Missing qonsole configuration file config/#{config_file_name}" unless File.exist?( config )

      @config = JSON.parse( IO.read( config ) ).with_indifferent_access
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
  end
end
