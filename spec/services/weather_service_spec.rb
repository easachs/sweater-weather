# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherService do
  it 'returns response body with lat/lon', vcr: 'denver_weather' do
    geocode = GeocodeFacade.geocode('Denver')
    denver = WeatherService.forecast(geocode)
    expect(denver).to be_a(Hash)
    expect(denver).to have_key(:lat)
    expect(denver[:lat]).to be_a(Float)
    expect(denver).to have_key(:lon)
    expect(denver[:lon]).to be_a(Float)
    expect(denver).to have_key(:timezone_offset)
    expect(denver[:timezone_offset]).to be_a(Integer)
    expect(denver[:lat]).to eq(geocode.lat.round(4))
    expect(denver[:lon]).to eq(geocode.lng.round(4))

    expect(denver).to have_key(:current)
    expect(denver[:current]).to be_a(Hash)
    expect(denver[:current]).to have_key(:dt)
    expect(denver[:current][:dt]).to be_a(Integer)
    expect(denver[:current]).to have_key(:sunrise)
    expect(denver[:current][:sunrise]).to be_a(Integer)
    expect(denver[:current]).to have_key(:sunset)
    expect(denver[:current][:sunset]).to be_a(Integer)
    expect(denver[:current]).to have_key(:temp)
    expect(denver[:current][:temp]).to be_a(Float)
    expect(denver[:current]).to have_key(:feels_like)
    expect(denver[:current][:feels_like]).to be_a(Float)
    expect(denver[:current]).to have_key(:humidity)
    expect(denver[:current][:humidity]).to be_a(Integer)
    expect(denver[:current]).to have_key(:uvi)
    expect(denver[:current]).to have_key(:visibility)
    expect(denver[:current][:visibility]).to be_a(Integer)
    expect(denver[:current]).to have_key(:weather)
    expect(denver[:current][:weather]).to be_a(Array)
    expect(denver[:current][:weather].first).to be_a(Hash)
    expect(denver[:current][:weather].first).to have_key(:description)
    expect(denver[:current][:weather].first[:description]).to be_a(String)
    expect(denver[:current][:weather].first).to have_key(:icon)
    expect(denver[:current][:weather].first[:icon]).to be_a(String)

    expect(denver).to have_key(:daily)
    expect(denver[:daily]).to be_a(Array)
    denver[:daily][0..4].each do |day|
      expect(day).to have_key(:dt)
      expect(day[:dt]).to be_a(Integer)
      expect(day).to have_key(:sunrise)
      expect(day[:sunrise]).to be_a(Integer)
      expect(day).to have_key(:sunset)
      expect(day[:sunset]).to be_a(Integer)
      expect(day).to have_key(:temp)
      expect(day[:temp]).to be_a(Hash)
      expect(day[:temp]).to have_key(:max)
      expect(day[:temp][:max]).to be_a(Float)
      expect(day[:temp]).to have_key(:min)
      expect(day[:temp][:min]).to be_a(Float)
      expect(day).to have_key(:weather)
      expect(day[:weather]).to be_a(Array)
      expect(day[:weather].first).to be_a(Hash)
      expect(day[:weather].first).to have_key(:description)
      expect(day[:weather].first[:description]).to be_a(String)
      expect(day[:weather].first).to have_key(:icon)
      expect(day[:weather].first[:icon]).to be_a(String)
    end

    expect(denver).to have_key(:hourly)
    expect(denver[:hourly]).to be_a(Array)
    denver[:hourly][0..7].each do |hour|
      expect(hour).to have_key(:dt)
      expect(hour[:dt]).to be_a(Integer)
      expect(hour).to have_key(:temp)
      expect(hour[:temp]).to be_a(Float)
      expect(hour).to have_key(:weather)
      expect(hour[:weather]).to be_a(Array)
      expect(hour[:weather].first).to be_a(Hash)
      expect(hour[:weather].first).to have_key(:description)
      expect(hour[:weather].first[:description]).to be_a(String)
      expect(hour[:weather].first).to have_key(:icon)
      expect(hour[:weather].first[:icon]).to be_a(String)
    end
  end

  it 'errors with no location', vcr: 'empty_weather' do
    geocode = GeocodeFacade.geocode('')
    none = WeatherService.forecast(geocode)
    expect(none).to be_a(Hash)
    expect(none).to have_key(:cod)
    expect(none[:cod]).to eq('400')
    expect(none).to have_key(:message)
    expect(none[:message]).to eq('Nothing to geocode')
  end
end
