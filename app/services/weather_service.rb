# frozen_string_literal: true

class WeatherService
  def self.forecast(geocode)
    response = conn.get('onecall') do |f|
      f.params['lat'] = geocode.lat
      f.params['lon'] = geocode.lng
      f.params['exclude'] = 'minutely'
      f.params['units'] = 'imperial'
    end
    parse_json(response)
  end

  def self.conn
    Faraday.new(url: 'http://api.openweathermap.org/data/2.5') do |f|
      f.params['appid'] = ENV['weather_key']
    end
  end

  def self.parse_json(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
