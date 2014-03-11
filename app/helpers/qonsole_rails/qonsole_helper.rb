module QonsoleRails
  module QonsoleHelper

    def render_examples( config )
      capture do
        config.queries.each do |example_query|
          render_button( example_query[:name], 'data-query' => example_query[:query] )
        end
      end
    end

    def render_prefixes( config )
      capture do
        config.prefixes.each do |prefix, uri|
          render_button( prefix, 'data-uri' => uri )
        end
      end
    end

    def render_button( value, options )
      concat(
        content_tag( "li" ) do
          tag( "input", {class: 'btn',
                         type: 'button',
                         value: value
                        }.merge( options )
             )
        end
      )
    end
  end
end
