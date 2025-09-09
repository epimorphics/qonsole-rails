# frozen_string_literal: true

require 'test_helper'

module QonsoleRails
  class SparqlQueryServiceTest < ActiveSupport::TestCase
    setup do
      @mock_config = Minitest::Mock.new
      @service = SparqlQueryService.new(@mock_config)
      @endpoint = 'http://landregistry.data.gov.uk/landregistry/query'
    end

    test 'creates a Faraday connection with timeout options' do
      # Proves we can set a timeout on the connection manually if needed
      @mock_config.expect :query_timeout, 30

      conn = @service.create_connection(@endpoint)

      assert_equal 30, conn.options[:timeout]
      @mock_config.verify
    end

    test 'adds appropriate headers for requested output format' do
      # Proves we can set the Accept header based on the requested output format
      @mock_config.expect :output_format, 'json'

      req = Struct.new(:headers).new({})
      @service.with_mime_type(req)

      assert_equal 'application/json', req.headers['Accept']
      @mock_config.verify
    end

    test 'ensure response is not json formatted by Faraday' do
      # Proves we do not use Faraday's JSON middleware to parse the response
      # as we want to handle it ourselves
      conn = @service.create_http_connection(@endpoint)

      assert_not_includes conn.builder.handlers, Faraday::Response::Json
    end

    test 'processes successful response' do
      # Proves we can process a successful response and count results
      json_response = { results: { bindings: [{ s: { value: 'subject' } }] } }.to_json
      mock_response = Minitest::Mock.new
      mock_response.expect :status, 200
      mock_response.expect :body, json_response
      mock_response.expect :status, 200

      @mock_config.expect :output_format, 'json'

      result = @service.as_result(mock_response)

      assert_equal 200, result[:status]
      assert_equal json_response, result[:result]
      assert_equal 1, result[:items].size

      @mock_config.verify
      mock_response.verify
    end

    test 'processes error response' do
      # Proves we can process an error response
      error_message = 'Error occurred'
      mock_response = Minitest::Mock.new
      mock_response.expect :status, 500
      mock_response.expect :body, error_message
      mock_response.expect :status, 500

      result = @service.as_result(mock_response)

      assert_equal 500, result[:status]
      assert_equal error_message, result[:error]
      assert_nil result[:result]
      mock_response.verify
    end

    test 'removes version information from response' do
      # Proves we can strip version information from a response string
      # to avoid leaking server details
      response_with_version = "Fuseki - version 0.0.0\nSome data"
      expected_response = "Apache Jena Fuseki\nSome data"

      result = @service.remove_version_information(response_with_version)

      assert_equal expected_response, result
    end

    test 'counts results for different output formats' do
      # Proves we can count results correctly for various output formats
      # JSON, CSV, TSV, XML, Plain Text
      @mock_config.expect :output_format, 'json'

      json_result = { result: '{"results":{"bindings":[{"s":{"value":"subject"}}]}}' }
      json_count = @service.count_results(json_result)
      assert_equal 1, json_count.size

      @mock_config.expect :output_format, 'csv'

      csv_result = { result: "header\nrow1\nrow2" }
      csv_count = @service.count_results(csv_result)
      assert_equal 2, csv_count.size

      @mock_config.verify
    end
  end
end
