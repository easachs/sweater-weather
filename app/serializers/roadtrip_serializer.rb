# frozen_string_literal: true

class RoadtripSerializer
  def self.roadtrip(origin, destination)
    roadtrip = GeocodeFacade.roadtrip(origin, destination)
    weather = WeatherFacade.forecast(destination)
    if roadtrip.time && roadtrip.hrs < 48
      {
        data: {
          id: nil,
          type: 'roadtrip',
          attributes: {
            start_city: roadtrip.start_city,
            end_city: roadtrip.end_city,
            travel_time: roadtrip.travel_time,
            weather_at_eta: {
              temperature: weather.hourly_weather[roadtrip.hrs][:temperature],
              conditions: weather.hourly_weather[roadtrip.hrs][:conditions]
            }
          }
        }
      }
    elsif roadtrip.time
      day = roadtrip.hrs / 24
      {
        data: {
          id: nil,
          type: 'roadtrip',
          attributes: {
            start_city: roadtrip.start_city,
            end_city: roadtrip.end_city,
            travel_time: roadtrip.travel_time,
            weather_at_eta: {
              temperature: weather.daily_weather[day][:max_temp],
              conditions: weather.daily_weather[day][:conditions]
            }
          }
        }
      }
    else
      {
        data: {
          id: nil,
          type: 'roadtrip',
          attributes: {
            start_city: roadtrip.start_city,
            end_city: roadtrip.end_city,
            travel_time: 'impossible route'
          }
        }
      }
    end
  end
end
