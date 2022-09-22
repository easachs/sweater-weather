# frozen_string_literal: true

class Geocode
  attr_reader :lat, :lng

  def initialize(data)
    @lat = data[:results].first[:locations].first[:latLng][:lat] if data[:results].first[:locations].any?
    @lng = data[:results].first[:locations].first[:latLng][:lng] if data[:results].first[:locations].any?
  end
end
