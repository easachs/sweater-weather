# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoadtripSerializer do
  it 'responds with formatted hash', vcr: 'trip_serializer' do
    roadtrip = RoadtripSerializer.roadtrip('Denver,CO', 'Boulder,CO')[:data]
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
    expect(roadtrip[:attributes][:travel_time]).to include('minutes')
    expect(roadtrip[:attributes]).to have_key(:weather_at_eta)
    expect(roadtrip[:attributes][:weather_at_eta]).to have_key(:temperature)
    expect(roadtrip[:attributes][:weather_at_eta]).to have_key(:conditions)
    expect(roadtrip[:attributes][:weather_at_eta][:conditions]).to be_a(String)
    expect(roadtrip[:attributes]).to_not have_key(:time)
  end

  it 'errors gracefully', vcr: 'bad_trip_serializer' do
    none = RoadtripSerializer.roadtrip('', '')[:data]
    expect(none).to be_a(Hash)
    expect(none[:id]).to be_nil
    expect(none[:type]).to eq('roadtrip')
    expect(none).to have_key(:attributes)
    expect(none[:attributes]).to be_a(Hash)

    expect(none[:attributes]).to have_key(:start_city)
    expect(none[:attributes][:start_city]).to be_nil
    expect(none[:attributes]).to have_key(:end_city)
    expect(none[:attributes][:end_city]).to be_nil
    expect(none[:attributes]).to have_key(:travel_time)
    expect(none[:attributes][:travel_time]).to eq('impossible route')
    expect(none[:attributes]).to_not have_key(:weather_at_eta)
  end
end
