# frozen_string_literal: true

class GeocodeFacade
  def self.geocode(location)
    service = GeocodeService.geocode(location)
    Geocode.new(service)
  end

  def self.roadtrip(origin = '', destination = '')
    service = GeocodeService.roadtrip(origin, destination)
    Roadtrip.new(service)
  end
end
