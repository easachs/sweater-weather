# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherSerializer do
  it 'responds with formatted hash', vcr: 'denver_forecast' do
    denver = WeatherSerializer.response_for('Denver,CO')
    expect(denver).to be_a(Hash)
    expect(denver[:id]).to be_nil
    expect(denver[:type]).to eq('forecast')
    expect(denver[:attributes]).to be_a(Hash)

    expect(denver[:attributes][:current_weather]).to be_a(Hash)
    expect(denver[:attributes][:current_weather]).to have_key(:datetime)
    expect(denver[:attributes][:current_weather][:datetime]).to be_a(String)
    expect(denver[:attributes][:current_weather]).to have_key(:sunrise)
    expect(denver[:attributes][:current_weather][:sunrise]).to be_a(String)
    expect(denver[:attributes][:current_weather]).to have_key(:sunset)
    expect(denver[:attributes][:current_weather][:sunset]).to be_a(String)
    expect(denver[:attributes][:current_weather]).to have_key(:temperature)
    expect(denver[:attributes][:current_weather][:temperature]).to be_a(Float)
    expect(denver[:attributes][:current_weather]).to have_key(:feels_like)
    expect(denver[:attributes][:current_weather][:feels_like]).to be_a(Float)
    expect(denver[:attributes][:current_weather]).to have_key(:humidity)
    expect(denver[:attributes][:current_weather]).to have_key(:uvi)
    expect(denver[:attributes][:current_weather]).to have_key(:visibility)
    expect(denver[:attributes][:current_weather][:visibility]).to be_a(Integer)
    expect(denver[:attributes][:current_weather]).to have_key(:conditions)
    expect(denver[:attributes][:current_weather][:conditions]).to be_a(String)
    expect(denver[:attributes][:current_weather]).to have_key(:icon)
    expect(denver[:attributes][:current_weather][:icon]).to be_a(String)

    expect(denver[:attributes][:daily_weather]).to be_a(Array)
    denver[:attributes][:daily_weather].each do |day|
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

    expect(denver[:attributes][:hourly_weather]).to be_a(Array)
    expect(denver[:attributes][:hourly_weather].length).to eq(8)

    denver[:attributes][:hourly_weather].each do |hour|
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

  it 'errors gracefully', vcr: 'empty_forecast' do
    none = WeatherSerializer.response_for('')
    expect(none).to be_a(Hash)
    expect(none).to have_key(:error)
    expect(none[:error]).to eq('location param required')
  end
end
