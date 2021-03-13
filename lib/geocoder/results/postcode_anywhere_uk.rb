# frozen_string_literal: true

require 'geocoder/results/base'

module Geocoder
  module Result
    class PostcodeAnywhereUk < Base
      def coordinates
        [@data['Latitude'].to_f, @data['Longitude'].to_f]
      end

      def blank_result
        ''
      end
      alias state blank_result
      alias state_code blank_result
      alias postal_code blank_result

      def address
        @data['Location']
      end

      def city
        # is this too big a jump to assume that the API always
        # returns a City, County as the last elements?
        city = @data['Location'].split(',')[-2] || blank_result
        city.strip
      end

      def os_grid
        @data['OsGrid']
      end

      # This is a UK only API; all results are UK specific and
      # so ommitted from API response.
      def country
        'United Kingdom'
      end

      def country_code
        'UK'
      end
    end
  end
end
