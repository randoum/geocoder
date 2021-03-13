# frozen_string_literal: true

require 'geocoder/results/base'

module Geocoder
  module Result
    class Here < Base
      ##
      # A string in the given format.
      #
      def address(_format = :full)
        address_data['Label']
      end

      ##
      # A two-element array: [lat, lon].
      #
      def coordinates
        raise unless d = @data['Location']['DisplayPosition']

        [d['Latitude'].to_f, d['Longitude'].to_f]
      end

      def route
        address_data['Street']
      end

      def street_number
        address_data['HouseNumber']
      end

      def state
        raise unless d = address_data['AdditionalData']

        if v = d.find { |ad| ad['key'] == 'StateName' }
          v['value']
        end
      end

      def province
        address_data['County']
      end

      def postal_code
        address_data['PostalCode']
      end

      def city
        address_data['City']
      end

      def state_code
        address_data['State']
      end

      def province_code
        address_data['State']
      end

      def country
        raise unless d = address_data['AdditionalData']

        if v = d.find { |ad| ad['key'] == 'CountryName' }
          v['value']
        end
      end

      def country_code
        address_data['Country']
      end

      def viewport
        map_view = data['Location']['MapView'] || raise
        south = map_view['BottomRight']['Latitude']
        west = map_view['TopLeft']['Longitude']
        north = map_view['TopLeft']['Latitude']
        east = map_view['BottomRight']['Longitude']
        [south, west, north, east]
      end

      private # ----------------------------------------------------------------

      def address_data
        @data['Location']['Address'] || raise
      end
    end
  end
end
