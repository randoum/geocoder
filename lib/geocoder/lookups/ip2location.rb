# frozen_string_literal: true

require 'geocoder/lookups/base'
require 'geocoder/results/ip2location'

module Geocoder
  module Lookup
    class Ip2location < Base
      def name
        'IP2LocationApi'
      end

      def supported_protocols
        %i[http https]
      end

      private # ----------------------------------------------------------------

      def base_query_url(_query)
        "#{protocol}://api.ip2location.com/?"
      end

      def query_url_params(query)
        params = super
        params.merge!(package: configuration[:package]) if configuration.key?(:package)
        params
      end

      def results(query)
        # don't look up a loopback or private address, just return the stored result
        return [reserved_result(query.text)] if query.internal_ip_address?
        return [] unless doc = fetch_data(query)

        if doc['response'] == 'INVALID ACCOUNT'
          raise_error(Geocoder::InvalidApiKey) || Geocoder.log(:warn, 'INVALID ACCOUNT')
          []
        else
          [doc]
        end
      end

      def reserved_result(_query)
        {
          'country_code' => 'INVALID IP ADDRESS',
          'country_name' => 'INVALID IP ADDRESS',
          'region_name' => 'INVALID IP ADDRESS',
          'city_name' => 'INVALID IP ADDRESS',
          'latitude' => 'INVALID IP ADDRESS',
          'longitude' => 'INVALID IP ADDRESS',
          'zip_code' => 'INVALID IP ADDRESS',
          'time_zone' => 'INVALID IP ADDRESS',
          'isp' => 'INVALID IP ADDRESS',
          'domain' => 'INVALID IP ADDRESS',
          'net_speed' => 'INVALID IP ADDRESS',
          'idd_code' => 'INVALID IP ADDRESS',
          'area_code' => 'INVALID IP ADDRESS',
          'weather_station_code' => 'INVALID IP ADDRESS',
          'weather_station_name' => 'INVALID IP ADDRESS',
          'mcc' => 'INVALID IP ADDRESS',
          'mnc' => 'INVALID IP ADDRESS',
          'mobile_brand' => 'INVALID IP ADDRESS',
          'elevation' => 'INVALID IP ADDRESS',
          'usage_type' => 'INVALID IP ADDRESS'
        }
      end
    end
  end
end
