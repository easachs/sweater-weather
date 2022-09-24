# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Forecast' do
  it 'returns formatted forecast', vcr: 'denver_forecast' do
    get '/api/v1/forecast?location=Denver,CO'
    expect(response).to be_successful
    denver = JSON.parse(response.body, symbolize_names: true)

    expect(denver).to have_key(:id)
    expect(denver[:id]).to be_nil
    expect(denver).to have_key(:type)
    expect(denver[:type]).to eq('forecast')
    expect(denver).to have_key(:attributes)
    expect(denver[:attributes]).to have_key(:current_weather)
    expect(denver[:attributes][:current_weather].keys.length).to eq(10)
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
    expect(denver[:attributes][:current_weather]).to_not have_key(:pressure)
    expect(denver[:attributes][:current_weather]).to_not have_key(:dew_point)
    expect(denver[:attributes][:current_weather]).to_not have_key(:clouds)
    expect(denver[:attributes][:current_weather]).to_not have_key(:wind_speed)
    expect(denver[:attributes][:current_weather]).to_not have_key(:wind_deg)
    expect(denver[:attributes][:current_weather]).to_not have_key(:wind_gust)

    expect(denver[:attributes]).to have_key(:daily_weather)
    expect(denver[:attributes][:daily_weather]).to be_a(Array)
    expect(denver[:attributes][:daily_weather].length).to eq(5)
    denver[:attributes][:daily_weather].each do |day|
      expect(day).to be_a(Hash)
      expect(day.keys.length).to eq(7)
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
      expect(day).to_not have_key(:moonrise)
      expect(day).to_not have_key(:moonset)
      expect(day).to_not have_key(:moon_phase)
      expect(day).to_not have_key(:pressure)
      expect(day).to_not have_key(:dew_point)
      expect(day).to_not have_key(:clouds)
      expect(day).to_not have_key(:wind_speed)
      expect(day).to_not have_key(:wind_deg)
      expect(day).to_not have_key(:wind_gust)
    end

    expect(denver[:attributes]).to have_key(:hourly_weather)
    expect(denver[:attributes][:hourly_weather]).to be_a(Array)
    expect(denver[:attributes][:hourly_weather].length).to eq(8)
    denver[:attributes][:hourly_weather].each do |hour|
      expect(hour).to be_a(Hash)
      expect(hour.keys.length).to eq(4)
      expect(hour).to have_key(:time)
      expect(hour[:time]).to be_a(String)
      expect(hour).to have_key(:temperature)
      expect(hour[:temperature]).to be_a(Float)
      expect(hour).to have_key(:conditions)
      expect(hour[:conditions]).to be_a(String)
      expect(hour).to have_key(:icon)
      expect(hour[:icon]).to be_a(String)
      expect(hour).to_not have_key(:feels_like)
      expect(hour).to_not have_key(:uvi)
      expect(hour).to_not have_key(:humidity)
      expect(hour).to_not have_key(:pressure)
      expect(hour).to_not have_key(:dew_point)
      expect(hour).to_not have_key(:clouds)
      expect(hour).to_not have_key(:wind_speed)
      expect(hour).to_not have_key(:wind_deg)
      expect(hour).to_not have_key(:wind_gust)
    end
  end

  it 'errors gracefully', vcr: 'no_forecast' do
    get '/api/v1/forecast'
    expect(response).to be_successful
    none = JSON.parse(response.body, symbolize_names: true)

    expect(none).to be_a(Hash)
    expect(none).to have_key(:error)
    expect(none.keys.length).to eq(1)
    expect(none[:error]).to eq('location param required')

    get '/api/v1/forecast?location='
    expect(response).to be_successful
    none = JSON.parse(response.body, symbolize_names: true)

    expect(none).to be_a(Hash)
    expect(none).to have_key(:error)
    expect(none.keys.length).to eq(1)
    expect(none[:error]).to eq('location param required')
  end
end
