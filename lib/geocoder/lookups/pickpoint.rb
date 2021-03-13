# frozen_string_literal: true

require 'geocoder/lookups/nominatim'
require 'geocoder/results/pickpoint'

module Geocoder
  module Lookup
    class Pickpoint < Nominatim
      def name
        'Pickpoint'
      end

      def supported_protocols
        [:https]
      end

      def required_api_key_parts
        ['api_key']
      end

      private # ----------------------------------------------------------------

      def base_query_url(query)
        method = query.reverse_geocode? ? 'reverse' : 'forward'
        "#{protocol}://api.pickpoint.io/v1/#{method}?"
      end

      def query_url_params(query)
        {
          key: configuration.api_key
        }.merge(super)
      end

      def results(query)
        return [] unless doc = fetch_data(query)

        raise_error(Geocoder::InvalidApiKey, 'Unauthorized') if !doc.is_a?(Array) && doc['message'] == 'Unauthorized'

        doc.is_a?(Array) ? doc : [doc]
      end
    end
  end
end
