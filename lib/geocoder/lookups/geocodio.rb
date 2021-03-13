# frozen_string_literal: true

require 'geocoder/lookups/base'
require 'geocoder/results/geocodio'

module Geocoder
  module Lookup
    class Geocodio < Base
      def name
        'Geocodio'
      end

      def results(query)
        return [] unless doc = fetch_data(query)
        return doc['results'] if doc['error'].nil?

        case doc['error']
        when 'Invalid API key'
          raise_error(Geocoder::InvalidApiKey) ||
            Geocoder.log(:warn, 'Geocodio service error: invalid API key.')
        when /You have reached your daily maximum/
          raise_error(Geocoder::OverQueryLimitError, doc['error']) ||
            Geocoder.log(:warn, "Geocodio service error: #{doc['error']}.")
        else
          raise_error(Geocoder::InvalidRequest, doc['error']) ||
            Geocoder.log(:warn, "Geocodio service error: #{doc['error']}.")
        end
        []
      end

      private # ---------------------------------------------------------------

      def base_query_url(query)
        path = query.reverse_geocode? ? 'reverse' : 'geocode'
        "#{protocol}://api.geocod.io/v1.6/#{path}?"
      end

      def query_url_params(query)
        {
          api_key: configuration.api_key,
          q: query.sanitized_text
        }.merge(super)
      end
    end
  end
end
