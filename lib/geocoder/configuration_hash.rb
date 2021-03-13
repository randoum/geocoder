# frozen_string_literal: true

module Geocoder
  class ConfigurationHash < Hash
    def method_missing(meth, *args, &block)
      key?(meth) ? self[meth] : super
    end

    def respond_to_missing?(meth, include_private = false)
      key?(meth) || super
    end
  end
end
