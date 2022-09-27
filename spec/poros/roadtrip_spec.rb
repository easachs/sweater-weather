# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Roadtrip do
  it 'exists and has attributes', vcr: 'trip_denver_boulder' do
    service = GeocodeService.roadtrip('Denver,CO', 'Boulder,CO')
    roadtrip = Roadtrip.new(service)
    expect(roadtrip).to be_a(Roadtrip)
    expect(roadtrip.start_city).to eq('Denver, CO')
    expect(roadtrip.end_city).to eq('Boulder, CO')
    expect(roadtrip.time).to be_a(Integer)
    expect(roadtrip.travel_time).to be_a(String)
    expect(roadtrip.travel_time).to include('hours,')
    expect(roadtrip.travel_time).to include('minutes')
  end

  it 'errors gracefully', vcr: 'trip_empty' do
    none_service = GeocodeService.roadtrip('', '')
    none = Roadtrip.new(none_service)
    expect(none).to be_a(Roadtrip)
    expect(none.start_city).to be_nil
    expect(none.end_city).to be_nil
    expect(none.time).to be_nil
    expect(none.travel_time).to be_nil
  end
end
