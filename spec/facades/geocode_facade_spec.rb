# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GeocodeFacade do
  it 'creates geocode poros', vcr: 'denver_geocode' do
    denver = GeocodeFacade.geocode('Denver,CO')
    expect(denver).to be_a(Geocode)
    expect(denver.lat).to eq(39.738453)
    expect(denver.lng).to eq(-104.984853)
  end

  it 'errors with no location', vcr: 'empty_geocode' do
    none = GeocodeFacade.geocode('')
    expect(none).to be_a(Geocode)
    expect(none.lat).to be_nil
    expect(none.lng).to be_nil
  end

  it 'creates roadtrip poros', vcr: 'trip_denver_boulder' do
    roadtrip = GeocodeFacade.roadtrip('Denver,CO', 'Boulder,CO')
    expect(roadtrip).to be_a(Roadtrip)
    expect(roadtrip.start_city).to eq('Denver, CO')
    expect(roadtrip.end_city).to eq('Boulder, CO')
    expect(roadtrip.time).to be_a(Integer)
    expect(roadtrip.travel_time).to be_a(String)
    expect(roadtrip.travel_time).to include('hours,')
    expect(roadtrip.travel_time).to include('minutes')
  end

  it 'errors with no location', vcr: 'trip_empty' do
    none = GeocodeFacade.roadtrip('', '')
    expect(none).to be_a(Roadtrip)
    expect(none.start_city).to be_nil
    expect(none.end_city).to be_nil
    expect(none.time).to be_nil
    expect(none.travel_time).to be_nil
  end
end
