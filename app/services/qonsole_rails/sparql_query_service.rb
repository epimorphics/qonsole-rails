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
      with_connection_timeout(create_http_connection(http_url))
    end

    def create_http_connection(http_url)
      Faraday.new(url: http_url) do |faraday|
        faraday.request :url_encoded
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.response :logger
        with_logger_if_rails(faraday)
        faraday.adapter :net_http
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

    def with_logger_if_rails(faraday)
      faraday.response(:logger, Rails.logger) if defined?(Rails)
    end

    def as_http_api(api)
      api.start_with?('http:') ? api : "#{url}#{api}"
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
