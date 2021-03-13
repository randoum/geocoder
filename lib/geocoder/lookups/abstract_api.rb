# frozen_string_literal: true

require 'geocoder/lookups/base'
require 'geocoder/results/abstract_api'

module Geocoder
  module Lookup
    class AbstractApi < Base
      def name
        'Abstract API'
      end

      def required_api_key_parts
        ['api_key']
      end

      def supported_protocols
        [:https]
      end

      private # ---------------------------------------------------------------

      def base_query_url(_query)
        "#{protocol}://ipgeolocation.abstractapi.com/v1/?"
      end

      def query_url_params(query)
        params = { api_key: configuration.api_key }

        ip_address = query.sanitized_text
        params[:ip_address] = ip_address if ip_address.is_a?(String) && ip_address.length.positive?

        params.merge(super)
      end

      def results(query, _reverse = false)
        if doc = fetch_data(query)
          [doc]
        else
          []
        end
      end
    end
  end
end
