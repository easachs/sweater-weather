# frozen_string_literal: true

class GeocodeFacade
  def self.geocode(city)
    service = GeocodeService.geocode(city)
    Geocode.new(service)
  end
end
