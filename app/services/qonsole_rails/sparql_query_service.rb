# frozen_string_literal: true

require_dependency 'faraday/encoding'

module QonsoleRails
  # Service object which manages the process of sending SPARQL queries to the remote endpoint
  class SparqlQueryService
    STANDARD_MIME_TYPES =
      'application/json,text/html,application/xhtml+xml,application/xml,text/plain'.freeze

    attr_reader :qonfig

    def initialize(qonfig)
      @qonfig = qonfig
    end

    def run
      endpoint = qonfig.service_destination
      conn = create_connection(endpoint)
      result = post_to_api(conn)
      as_result(result)
    rescue Faraday::ClientError => e
      # Faraday client error class. Represents 4xx status responses.
      Rails.logger.warn(e)
      # 404 is a valid response for a non-existent endpoint
      # and should not be raised as an error
      raise e.to_s if e.response[:status] != 404
    rescue Faraday::ServerError => e
      # Faraday server error class. Represents 5xx status responses.
      Rails.logger.error(e)
      raise e.to_s
    end

    def get_from_api(conn)
      conn.get do |req|
        with_mime_type(req)
        add_sparql_service_params(req)
      end
    end

    def post_to_api(conn)
      conn.post do |req|
        with_mime_type(req)
        req.body = qonfig.sparql_service_options
      end
    end

    def as_result(response)
      result = { status: response.status }
      result[ok?(response) ? :result : :error] = response_body(response)
      result
    end

    def response_body(response)
      remove_version_information(response.body)
    end

    def create_connection(http_url)
      Rails.logger.debug { "Connecting to #{http_url}" }

      with_connection_timeout(create_http_connection(http_url))
    end

    def create_http_connection(http_url, auth: false)
      Faraday.new(url: http_url) do |config|
        config.use Faraday::Request::UrlEncoded
        config.use Faraday::Request::Retry
        config.use FaradayMiddleware::FollowRedirects

        config.basic_auth(api_user, api_pw) if auth

        config.response :encoding
        config.response :raise_error
        with_logger_if_rails(config)

        # setting the adapter must be the final step, otherwise we get a warning from Faraday
        config.adapter(:net_http)
      end
    end

    def with_connection_timeout(conn)
      conn.options[:timeout] = qonfig.query_timeout
      conn
    end

    def with_mime_type(req)
      req.headers['Accept'] = output_as_mime(qonfig.output_format)
    end

    def add_sparql_service_params(req)
      req.params.merge!(qonfig.sparql_service_options)
    end

    def ok?(response)
      (200..207).cover?(response.status)
    end

    def with_logger_if_rails(config)
      return config.response :logger unless defined?(Rails)

      level = Rails.env.production? ? :info : :debug
      config.response(
        :logger,
        Rails.logger,
        headers: false,
        bodies: false,
        errors: true,
        log_level: level.to_sym
      )
    end

    def as_http_api(api)
      uri = URI.parse(api)
      uri.scheme ? api : "#{url}#{api}"
    end

    # To keep the penetration test auditors happy
    def remove_version_information(text)
      text.gsub(/Fuseki - version.*(\n|\Z)/, 'Apache Jena Fuseki')
    end

    private

    def output_as_mime(output_format)
      return STANDARD_MIME_TYPES unless output_format

      {
        tsv: 'text/tab-separated-values',
        csv: 'text/csv',
        json: 'application/json',
        xml: 'text/xml',
        text: 'text/plain'
      }[output_format.to_sym]
    end
  end
end
