# frozen_string_literal: true

require 'geocoder/lookups/base'

module Geocoder
  module Result
    class SmartyStreets < Base
      def coordinates
        result = %w[latitude longitude].map do |i|
          zipcode_endpoint? ? zipcodes.first[i] : metadata[i]
        end

        if result.compact.empty?
          nil
        else
          result
        end
      end

      def address
        parts =
          if international_endpoint?
            (1..12).map { |i| @data["address#{i}"] }
          else
            [
              delivery_line_1,
              delivery_line_2,
              last_line
            ]
          end
        parts.reject { |i| i.to_s == '' }.join(' ')
      end

      def state
        if international_endpoint?
          components['administrative_area']
        elsif zipcode_endpoint?
          city_states.first['state']
        else
          components['state_abbreviation']
        end
      end

      def state_code
        if international_endpoint?
          components['administrative_area']
        elsif zipcode_endpoint?
          city_states.first['state_abbreviation']
        else
          components['state_abbreviation']
        end
      end

      def country
        if international_endpoint?
          components['country_iso_3']
        else
          'United States'
        end
      end

      def country_code
        if international_endpoint?
          components['country_iso_3']
        else
          'US'
        end
      end

      ## Extra methods not in base.rb ------------------------

      def street
        if international_endpoint?
          components['thoroughfare_name']
        else
          components['street_name']
        end
      end

      def city
        if international_endpoint?
          components['locality']
        elsif zipcode_endpoint?
          city_states.first['city']
        else
          components['city_name']
        end
      end

      def zipcode
        if international_endpoint?
          components['postal_code']
        elsif zipcode_endpoint?
          zipcodes.first['zipcode']
        else
          components['zipcode']
        end
      end
      alias postal_code zipcode

      def zip4
        components['plus4_code']
      end
      alias postal_code_extended zip4

      def fips
        if zipcode_endpoint?
          zipcodes.first['county_fips']
        else
          metadata['county_fips']
        end
      end

      def zipcode_endpoint?
        zipcodes.any?
      end

      def international_endpoint?
        !@data['address1'].nil?
      end

      %i[
        delivery_line_1
        delivery_line_2
        last_line
        delivery_point_barcode
        addressee
      ].each do |m|
        define_method(m) do
          @data[m.to_s] || ''
        end
      end

      %i[
        components
        metadata
        analysis
      ].each do |m|
        define_method(m) do
          @data[m.to_s] || {}
        end
      end

      %i[
        city_states
        zipcodes
      ].each do |m|
        define_method(m) do
          @data[m.to_s] || []
        end
      end
    end
  end
end
