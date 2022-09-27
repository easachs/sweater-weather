# frozen_string_literal: true

class GeocodeService
  def self.geocode(location)
    response = conn.get('geocoding/v1/address') do |f|
      f.params['location'] = location
    end
    parse_json(response)
  end

  def self.roadtrip(origin, destination)
    response = conn.get('directions/v2/route') do |f|
      f.params['from'] = origin
      f.params['to'] = destination
    end
    parse_json(response)
  end

  def self.conn
    Faraday.new(url: 'http://www.mapquestapi.com') do |f|
      f.params['key'] = ENV['map_key']
    end
  end

  def self.parse_json(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
