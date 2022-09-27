# frozen_string_literal: true

class WeatherSerializer
  def self.response_for(location)
    weather = WeatherFacade.forecast(location)
    if ['', nil].include?(location)
      { error: 'location param required' }
    else
      {
        id: weather.id,
        type: weather.type,
        attributes: {
          current_weather: weather.current_weather,
          daily_weather: weather.daily_weather,
          hourly_weather: weather.hourly_weather[0..7]
        }
      }
    end
  end
end
