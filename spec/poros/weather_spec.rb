# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Weather do
  it 'exists and has attributes', vcr: 'denver_weather' do
    geocode = GeocodeFacade.geocode('Denver')
    service = WeatherService.forecast(geocode)
    denver = Weather.new(service)
    expect(denver.id).to be_nil
    expect(denver.type).to eq('forecast')
    expect(denver.current_weather).to be_a(Hash)
    expect(denver.current_weather).to have_key(:datetime)
    expect(denver.current_weather[:datetime]).to be_a(String)
    expect(denver.current_weather).to have_key(:sunrise)
    expect(denver.current_weather[:sunrise]).to be_a(String)
    expect(denver.current_weather).to have_key(:sunset)
    expect(denver.current_weather[:sunset]).to be_a(String)
    expect(denver.current_weather).to have_key(:temperature)
    expect(denver.current_weather[:temperature]).to be_a(Float)
    expect(denver.current_weather).to have_key(:feels_like)
    expect(denver.current_weather[:feels_like]).to be_a(Float)
    expect(denver.current_weather).to have_key(:humidity)
    expect(denver.current_weather).to have_key(:uvi)
    expect(denver.current_weather).to have_key(:visibility)
    expect(denver.current_weather[:visibility]).to be_a(Integer)
    expect(denver.current_weather).to have_key(:conditions)
    expect(denver.current_weather[:conditions]).to be_a(String)
    expect(denver.current_weather).to have_key(:icon)
    expect(denver.current_weather[:icon]).to be_a(String)

    expect(denver.daily_weather).to be_a(Array)
    denver.daily_weather.each do |day|
      expect(day).to be_a(Hash)
      expect(day).to have_key(:date)
      expect(day[:date]).to be_a(String)
      expect(day).to have_key(:sunrise)
      expect(day[:sunrise]).to be_a(String)
      expect(day).to have_key(:sunset)
      expect(day[:sunset]).to be_a(String)
      expect(day).to have_key(:max_temp)
      expect(day[:max_temp]).to be_a(Float)
      expect(day).to have_key(:min_temp)
      expect(day[:min_temp]).to be_a(Float)
      expect(day).to have_key(:conditions)
      expect(day[:conditions]).to be_a(String)
      expect(day).to have_key(:icon)
      expect(day[:icon]).to be_a(String)
    end

    expect(denver.hourly_weather).to be_a(Array)
    expect(denver.hourly_weather.length).to eq(48)
    denver.hourly_weather.each do |hour|
      expect(hour).to be_a(Hash)
      expect(hour).to have_key(:time)
      expect(hour[:time]).to be_a(String)
      expect(hour).to have_key(:temperature)
      expect(hour[:temperature]).to be_a(Float)
      expect(hour).to have_key(:conditions)
      expect(hour[:conditions]).to be_a(String)
      expect(hour).to have_key(:icon)
      expect(hour[:icon]).to be_a(String)
    end
  end

  it 'errors gracefully', vcr: 'empty_weather' do
    geocode = GeocodeFacade.geocode('')
    none_service = WeatherService.forecast(geocode)
    none = Weather.new(none_service)
    expect(none.id).to be_nil
    expect(none.type).to eq('forecast')
    expect(none.current_weather).to be_nil
    expect(none.daily_weather).to be_nil
    expect(none.hourly_weather).to be_nil
  end
end
