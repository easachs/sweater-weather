# frozen_string_literal: true

class GeocodeService
  def self.geocode(city)
    response = conn.get('address') do |f|
      f.params['location'] = city
    end
    parse_json(response)
  end

  def self.conn
    Faraday.new(url: 'http://www.mapquestapi.com/geocoding/v1') do |f|
      f.params['key'] = ENV['map_key']
    end
  end

  def self.parse_json(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
