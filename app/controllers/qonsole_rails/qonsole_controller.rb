require_dependency "qonsole_rails/application_controller"

module QonsoleRails
  class QonsoleController < ApplicationController
    layout "application"

    def index
      @qconfig = QonsoleConfig.new( params, hostname )
    end

    def create
      qonfig = QonsoleConfig.new( params, hostname )

      if qonfig.valid_endpoint?
        query_service = QonsoleRails::SparqlQueryService.new( qonfig )
        render json: query_service.run, layout: false
      else
        render text: "You do not have access to the given SPARQL endpoint", status: :forbidden, layout: false
      end
    end

    :private

    def hostname
      "http://{request.host}"
    end
  end
end
