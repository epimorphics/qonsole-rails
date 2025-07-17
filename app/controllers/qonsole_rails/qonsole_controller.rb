# frozen_string_literal: true

require_dependency 'qonsole_rails/application_controller'

module QonsoleRails
  # Controller for Qonsole Rails engine
  class QonsoleController < ApplicationController
    layout 'application'

    def index
      @qconfig = QonsoleConfig.new(params, host: hostname)
    end

    def create # rubocop:disable Metrics/MethodLength
      qonfig = QonsoleConfig.new(params, host: hostname)

      if qonfig.valid_endpoint?
        query_service = QonsoleRails::SparqlQueryService.new(qonfig)
        json = query_service.run
        render(
          json: json,
          status: :ok,
          layout: false
        )
      else
        render(
          plain: 'You do not have access to the given SPARQL endpoint',
          status: :forbidden,
          layout: false
        )
      end
    end

    unless Rails.application.config.consider_all_requests_local
      rescue_from ActionController::RoutingError, with: :render_404 # rubocop:disable Naming/VariableNumber
      rescue_from Exception, with: :render_exception
    end

    def render_exception(err) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      if err.instance_of?(ArgumentError) || err.instance_of?(RuntimeError)
        render_error(400, err)
      elsif err.instance_of? ActionController::InvalidAuthenticityToken
        Rails.logger.warn "Invalid authenticity token #{err}"
        render_error(403, err)
      elsif err.instance_of?(Faraday::TimeoutError) || err.instance_of?(Faraday::ConnectionFailed)
        Rails.logger.error "Connection error: #{err}"
        render_error(504, err)
      else
        Rails.logger.warn "No explicit error page for exception #{err} - #{err.class.name}"
        render_error(500, err)
      end
    end

    def render_404(err = nil) # rubocop:disable Naming/VariableNumber
      render_error(404, err)
    end

    def render_error(status, err)
      respond_to do |format|
        format.html { render_error_message(status) }

        format.all { render text: err || Rack::Utils::HTTP_STATUS_CODES[status].to_s, status: status } # rubocop:disable Layout/LineLength
      end
    end

    def render_error_message(status)
      render(
        plain: "Sorry, that didn't work because: #{Rack::Utils::HTTP_STATUS_CODES[status]}",
        status: status,
        layout: false
      )
    end

    private

    # Responding to issue #9, we need to check which protocol to use for the hostname
    # we are sending the query to. There are three cases:
    #
    # - header `X-Forwarded-Proto` is set, meaning that we're most likely in a load-
    #   balancer and need to respect the original request
    # - the protocol is specified by the request that we have received
    # - default to `http` for compatibility with previous versions
    def hostname
      protocol = request.headers['HTTP_X_FORWARDED_PROTO'] ||
                 request.protocol ||
                 'http'
      protocol += '://' unless protocol.match?(%r{://})
      host = request.headers['HTTP_X_FORWARDED_HOST'] || request.host

      raise StandardError, "Invalid host: #{host}" if host.blank?

      "#{protocol}#{host}"
    end
  end
end
