module QonsoleRails
  # :nodoc:
  module QonsoleHelper
    def render_examples(config)
      capture do
        render_button('current search selection', 'data-query' => config.query) if config.query

        config.queries.each do |example_query|
          render_button(example_query[:name], 'data-query' => example_query[:query])
        end
      end
    end

    def render_prefixes(config)
      capture do
        config.prefixes.each do |prefix, uri|
          concat render_checkbox(prefix, uri)
        end
      end
    end

    def render_endpoints(config)
      capture do
        render_endpoint_item(:current_search, config.given_endpoint) if config.given_endpoint

        config.endpoints.each do |key, endpoint_url|
          render_endpoint_item(key, endpoint_url)
        end
      end
    end

    def render_button(value, options)
      concat(
        content_tag('li') do
          tag('input', { class: 'btn',
                         type: 'button',
                         value: value }.merge(options))
        end
      )
    end

    def render_checkbox(label, uri, options = {}) # rubocop:disable Metrics/MethodLength
      capture do
        concat(
          content_tag('label') do
            concat tag('input', { class: 'checkbox',
                                  type: 'checkbox',
                                  value: uri,
                                  checked: true }.merge(options))
            concat " #{label}"
          end
        )
      end
    end

    def render_endpoint_item(key, endpoint_url)
      concat(
        content_tag('li', role: 'presentation') do
          content_tag('a', role: 'menuitem', tabindex: -1, href: '#', data: { key: key }) do
            endpoint_url
          end
        end
      )
    end
  end
end
