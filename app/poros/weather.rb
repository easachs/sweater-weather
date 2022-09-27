# frozen_string_literal: true

require 'date'

class Weather
  attr_reader :id, :type, :attributes

  def initialize(data)
    @id = nil
    @type = 'forecast'
    @attributes = data
  end

  def current_weather
    if attributes[:current]
      {
        datetime: Time.at(attributes[:current][:dt]).to_datetime.strftime('%F %T %z'),
        sunrise: Time.at(attributes[:current][:sunrise]).to_datetime.strftime('%F %T %z'),
        sunset: Time.at(attributes[:current][:sunset]).to_datetime.strftime('%F %T %z'),
        temperature: attributes[:current][:temp].to_f,
        feels_like: attributes[:current][:feels_like].to_f,
        humidity: attributes[:current][:humidity],
        uvi: attributes[:current][:uvi],
        visibility: attributes[:current][:visibility],
        conditions: attributes[:current][:weather].first[:description],
        icon: attributes[:current][:weather].first[:icon]
      }
    end
  end

  def daily_weather
    if attributes[:daily]
      attributes[:daily][0..4].map do |day|
        {
          date: Time.at(day[:dt]).to_datetime.strftime('%F'),
          sunrise: Time.at(day[:sunrise]).to_datetime.strftime('%F %T %z'),
          sunset: Time.at(day[:sunset]).to_datetime.strftime('%F %T %z'),
          max_temp: day[:temp][:max].to_f,
          min_temp: day[:temp][:min].to_f,
          conditions: day[:weather].first[:description],
          icon: day[:weather].first[:icon]
        }
      end
    end
  end

  def hourly_weather
    attributes[:hourly]&.map do |hour|
      {
        time: Time.at(hour[:dt]).to_datetime.strftime('%T'),
        temperature: hour[:temp].to_f,
        conditions: hour[:weather].first[:description],
        icon: hour[:weather].first[:icon]
      }
    end
  end
end
