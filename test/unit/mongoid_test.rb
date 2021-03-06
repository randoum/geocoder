# frozen_string_literal: true

require 'mongoid_test_helper'

class MongoidTest < GeocoderTestCase
  def test_geocoded_check
    p = PlaceUsingMongoid.new(*geocoded_object_params(:msg))
    p.location = [40.750354, -73.993371]
    assert p.geocoded?
  end

  def test_geocoded_check_single_coord
    p = PlaceUsingMongoid.new(*geocoded_object_params(:msg))
    p.location = [40.750354, nil]
    assert !p.geocoded?
  end

  def test_distance_to_returns_float
    p = PlaceUsingMongoid.new(*geocoded_object_params(:msg))
    p.location = [40.750354, -73.993371]
    assert p.distance_to([30, -94]).is_a?(Float)
  end

  def test_model_configuration
    p = PlaceUsingMongoid.new(*geocoded_object_params(:msg))
    p.location = [0, 0]

    PlaceUsingMongoid.geocoded_by :address, coordinates: :location, units: :km
    assert_equal 111, p.distance_to([0, 1]).round

    PlaceUsingMongoid.geocoded_by :address, coordinates: :location, units: :mi
    assert_equal 69, p.distance_to([0, 1]).round
  end

  def test_index_is_skipped_if_skip_option_flag
    result = if PlaceUsingMongoidWithoutIndex.respond_to?(:index_options)
               PlaceUsingMongoidWithoutIndex.index_options.keys.flatten[0] == :coordinates
             else
               PlaceUsingMongoidWithoutIndex.index_specifications[0] == :coordinates
             end
    assert !result
  end

  def test_geocoded_with_custom_handling
    p = PlaceUsingMongoidWithCustomResultsHandling.new(*geocoded_object_params(:msg))
    p.location = [40.750354, -73.993371]
    p.geocode
    assert_match(/[0-9.,\-]+/, p.coords_string)
  end

  def test_reverse_geocoded
    p = PlaceUsingMongoidReverseGeocoded.new(*reverse_geocoded_object_params(:msg))
    p.reverse_geocode
    assert_match(/New York/, p.address)
  end

  def test_reverse_geocoded_with_custom_handling
    p = PlaceUsingMongoidReverseGeocodedWithCustomResultsHandling.new(*reverse_geocoded_object_params(:msg))
    p.reverse_geocode
    assert_equal 'US', p.country.upcase
  end
end
