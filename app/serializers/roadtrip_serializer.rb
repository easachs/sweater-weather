# frozen_string_literal: true

class RoadtripSerializer
  def self.roadtrip(origin, destination)
    roadtrip = GeocodeFacade.roadtrip(origin, destination)
    weather = WeatherFacade.forecast(destination)
    if roadtrip.time
      {
        data: {
          id: nil,
          type: 'roadtrip',
          attributes: {
            start_city: roadtrip.start_city,
            end_city: roadtrip.end_city,
            travel_time: [0, nil].include?(roadtrip.time) ? 'impossible route' : roadtrip.travel_time,
            weather_at_eta: {
              temperature: weather.current_weather[:temperature],
              conditions: weather.current_weather[:conditions]
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
            travel_time: [0, nil].include?(roadtrip.time) ? 'impossible route' : roadtrip.travel_time
          }
        }
      }
    end
  end
end
