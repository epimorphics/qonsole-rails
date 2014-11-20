require_dependency "qonsole_rails/application_controller"

module QonsoleRails
  class QonsoleController < ApplicationController
    layout "application"

    def index
      qconfig
    end

    def create
      qconfig
      query = params[:q]
      url = params[:url]
      output = params[:output]

      result = get_from_api( url, {query: query, output: output})

      render json: result, layout: false
    end

    def qconfig
      @qconfig ||= QonsoleConfig.new( params )
    end

    # probably should refactor all this to a service object
    def get_from_api( http_url, options )
      conn = set_connection_timeout( create_http_connection( http_url ) )
      output_format = options[:output]

      response = conn.get do |req|
        req.headers['Accept'] = "application/json,text/html,application/xhtml+xml,application/xml,text/plain" #output_to_mime( output_format )
        req.params.merge! options
      end

      result = {status: response.status}

      if ok?(response)
        result[:result] = remove_version_information( response.body )
      else
        result[:error] = response.body
      end

      result
    end

    def create_http_connection( http_url )
      Faraday.new( url: http_url ) do |faraday|
        faraday.request  :url_encoded
        faraday.use      FaradayMiddleware::FollowRedirects
        faraday.adapter  :net_http
        faraday.response :logger
        set_logger_if_rails( faraday )
      end
    end

    def set_connection_timeout( conn )
      conn.options[:timeout] = 60
      conn
    end

    def ok?( response )
      (200..207).include?( response.status )
    end

    def set_logger_if_rails( faraday )
      if defined?( Rails )
        faraday.response :logger, Rails.logger
      end
    end

    def as_http_api( api )
      api.start_with?( "http:" ) ? api : "#{url}#{api}"
    end

    def output_to_mime( output_format )
      { tsv: "text/tab-separated-values",
        csv: "text/csv",
        json: "application/json",
        xml: "text/xml",
        text: "text/plain"
      }[output_format.to_sym]
    end

    # To keep the penetration test auditors happy
    def remove_version_information( text )
      text.gsub( /Fuseki - version.*(\n|\Z)/, "Apache Jena Fuseki" )
    end

  end
end
