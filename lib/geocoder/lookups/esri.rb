# frozen_string_literal: true

require 'geocoder/lookups/base'
require 'geocoder/results/esri'
require 'geocoder/esri_token'

module Geocoder
  module Lookup
    class Esri < Base
      def name
        'Esri'
      end

      def supported_protocols
        [:https]
      end

      private # ---------------------------------------------------------------

      def base_query_url(query)
        action = query.reverse_geocode? ? 'reverseGeocode' : 'find'
        "#{protocol}://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/#{action}?"
      end

      def results(query)
        return [] unless doc = fetch_data(query)

        return [] unless query.reverse_geocode? && (!doc['locations'] || doc['locations'].empty?)

        if doc['error'].nil?
          [doc]
        else
          []
        end
      end

      def query_url_params(query)
        params = {
          f: 'pjson',
          outFields: '*'
        }
        if query.reverse_geocode?
          params[:location] = query.coordinates.reverse.join(',')
        else
          params[:text] = query.sanitized_text
        end

        params[:token] = token(query)

        if for_storage_value = for_storage(query)
          params[:forStorage] = for_storage_value
        end
        params[:sourceCountry] = configuration[:source_country] if configuration[:source_country]
        params[:preferredLabelValues] = configuration[:preferred_label_values] if configuration[:preferred_label_values]

        params.merge(super)
      end

      def for_storage(query)
        if query.options.key?(:for_storage)
          query.options[:for_storage]
        else
          configuration[:for_storage]
        end
      end

      def token(query)
        token_instance = query.options[:token] || configuration[:token]

        if !valid_token_configured?(token_instance) && configuration.api_key
          token_instance = create_and_save_token!(query)
        end

        token_instance&.to_s
      end

      def valid_token_configured?(token_instance)
        !token_instance.nil? && token_instance.active?
      end

      def create_and_save_token!(query)
        token_instance = create_token

        if query.options[:token]
          query.options[:token] = token_instance
        else
          Geocoder.merge_into_lookup_config(:esri, token: token_instance)
        end

        token_instance
      end

      def create_token
        Geocoder::EsriToken.generate_token(*configuration.api_key)
      end
    end
  end
end
