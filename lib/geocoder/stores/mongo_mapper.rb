# frozen_string_literal: true

require 'geocoder/stores/base'
require 'geocoder/stores/mongo_base'

module Geocoder
  module Store
    module MongoMapper
      include Base
      include MongoBase

      def self.included(base)
        MongoBase.included_by_model(base)
      end
    end
  end
end
