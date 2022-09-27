# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Roadtrip request' do
  before :each do
    User.create!(email: 'e@g', password: 'test', password_confirmation: 'test')
  end

  it 'returns formatted roadtrip', vcr: 'trip_serializer' do
    params = {
      origin: 'Denver,CO',
      destination: 'Boulder,CO',
      api_key: User.last.api_key
    }

    post '/api/v1/road_trip', params: params.to_json
    expect(response).to be_successful
    roadtrip = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(roadtrip).to be_a(Hash)
    expect(roadtrip[:id]).to be_nil
    expect(roadtrip[:type]).to eq('roadtrip')
    expect(roadtrip).to have_key(:attributes)
    expect(roadtrip[:attributes]).to be_a(Hash)

    expect(roadtrip[:attributes]).to have_key(:start_city)
    expect(roadtrip[:attributes][:start_city]).to eq('Denver, CO')
    expect(roadtrip[:attributes]).to have_key(:end_city)
    expect(roadtrip[:attributes][:end_city]).to eq('Boulder, CO')
    expect(roadtrip[:attributes]).to have_key(:travel_time)
    expect(roadtrip[:attributes][:travel_time]).to be_a(String)
    expect(roadtrip[:attributes][:travel_time]).to include('hours, ')
    expect(roadtrip[:attributes][:travel_time]).to include('minutes')
    expect(roadtrip[:attributes]).to have_key(:weather_at_eta)
    expect(roadtrip[:attributes][:weather_at_eta]).to have_key(:temperature)
    expect(roadtrip[:attributes][:weather_at_eta]).to have_key(:conditions)
    expect(roadtrip[:attributes][:weather_at_eta][:conditions]).to be_a(String)
    expect(roadtrip[:attributes]).to_not have_key(:time)
  end

  it 'sad path impossible route', vcr: 'impossible_trip' do
    params = {
      origin: 'New York,NY',
      destination: 'London,UK',
      api_key: User.last.api_key
    }

    post '/api/v1/road_trip', params: params.to_json

    expect(response).to be_successful
    impossible = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(impossible).to be_a(Hash)
    expect(impossible[:id]).to be_nil
    expect(impossible[:type]).to eq('roadtrip')
    expect(impossible).to have_key(:attributes)
    expect(impossible[:attributes]).to be_a(Hash)

    expect(impossible[:attributes]).to have_key(:start_city)
    expect(impossible[:attributes][:start_city]).to be_nil
    expect(impossible[:attributes]).to have_key(:end_city)
    expect(impossible[:attributes][:end_city]).to be_nil
    expect(impossible[:attributes]).to have_key(:travel_time)
    expect(impossible[:attributes][:travel_time]).to be_a(String)
    expect(impossible[:attributes][:travel_time]).to eq('impossible route')
    expect(impossible[:attributes]).to have_key(:weather_at_eta)
    expect(impossible[:attributes][:weather_at_eta]).to have_key(:temperature)
    expect(impossible[:attributes][:weather_at_eta]).to have_key(:conditions)
    expect(impossible[:attributes][:weather_at_eta][:conditions]).to be_a(String)
  end

  it 'sad path bad api key' do
    params = {
      origin: 'Denver,CO',
      destination: 'Boulder,CO',
      api_key: '123'
    }

    post '/api/v1/road_trip', params: params.to_json

    expect(response.status).to eq(401)
    none = JSON.parse(response.body, symbolize_names: true)

    expect(none).to be_a(Hash)
    expect(none).to have_key(:error)
    expect(none.keys.length).to eq(1)
    expect(none[:error]).to eq('invalid credentials')
  end

  it 'sad path no api key' do
    params = {
      origin: 'Denver,CO',
      destination: 'Boulder,CO'
    }

    post '/api/v1/road_trip', params: params.to_json

    expect(response.status).to eq(401)
    none = JSON.parse(response.body, symbolize_names: true)

    expect(none).to be_a(Hash)
    expect(none).to have_key(:error)
    expect(none.keys.length).to eq(1)
    expect(none[:error]).to eq('invalid credentials')
  end

  it 'sad path missing destination' do
    params = {
      origin: 'Denver,CO',
      api_key: User.last.api_key
    }

    post '/api/v1/road_trip', params: params.to_json

    expect(response.status).to eq(400)
    none = JSON.parse(response.body, symbolize_names: true)

    expect(none).to be_a(Hash)
    expect(none).to have_key(:error)
    expect(none.keys.length).to eq(1)
    expect(none[:error]).to eq('you must include origin and destination')
  end

  it 'sad path missing origin' do
    params = {
      destination: 'Boulder,CO',
      api_key: User.last.api_key
    }

    post '/api/v1/road_trip', params: params.to_json

    expect(response.status).to eq(400)
    none = JSON.parse(response.body, symbolize_names: true)

    expect(none).to be_a(Hash)
    expect(none).to have_key(:error)
    expect(none.keys.length).to eq(1)
    expect(none[:error]).to eq('you must include origin and destination')
  end
end
