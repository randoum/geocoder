# frozen_string_literal: true

require 'geocoder/lookups/base'
require 'geocoder/results/yandex'

module Geocoder
  module Lookup
    class Yandex < Base
      def name
        'Yandex'
      end

      def map_link_url(coordinates)
        "http://maps.yandex.ru/?ll=#{coordinates.reverse.join(',')}"
      end

      def supported_protocols
        [:https]
      end

      private # ---------------------------------------------------------------

      def base_query_url(_query)
        "#{protocol}://geocode-maps.yandex.ru/1.x/?"
      end

      def results(query)
        return [] unless doc = fetch_data(query)

        if err = doc['error']
          if (err['status'] == 401) && (err['message'] == 'invalid key')
            raise_error(Geocoder::InvalidApiKey) || Geocoder.log(:warn, 'Invalid API key.')
          else
            Geocoder.log(:warn, "Yandex Geocoding API error: #{err['status']} (#{err['message']}).")
          end
          return []
        end
        if doc = doc['response']['GeoObjectCollection']
          doc['featureMember'].to_a
        else
          Geocoder.log(:warn, 'Yandex Geocoding API error: unexpected response format.')
          []
        end
      end

      def query_url_params(query)
        q = if query.reverse_geocode?
              query.coordinates.reverse.join(',')
            else
              query.sanitized_text
            end
        params = {
          geocode: q,
          format: 'json',
          lang: (query.language || configuration.language).to_s, # supports ru, uk, be, default -> ru
          apikey: configuration.api_key
        }
        unless (bounds = query.options[:bounds]).nil?
          params[:bbox] = bounds.map { |point| '%f,%f' % point }.join('~')
        end
        params.merge(super)
      end
    end
  end
end
