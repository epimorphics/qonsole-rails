module QonsoleRails
  module QonsoleHelper

    def render_examples( config )
      capture do
        config.queries.each do |example_query|
          concat(
            content_tag( "li" ) do
              tag( "input", {class: 'btn',
                             type: 'button',
                             value: example_query[:name],
                             'data-query' => example_query[:query]
                            } )
            end
          )
        end
      end
    end
  end
end
