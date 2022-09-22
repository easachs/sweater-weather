# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GeocodeService do
  it 'returns response body with lat/lon', vcr: 'denver_geocode' do
    denver = GeocodeService.geocode('Denver,CO')
    expect(denver).to be_a(Hash)
    expect(denver).to have_key(:info)
    expect(denver[:info]).to have_key(:statuscode)
    expect(denver[:info][:statuscode]).to eq(0)
    expect(denver).to have_key(:results)
    expect(denver[:results].first).to have_key(:locations)
    expect(denver[:results].first[:locations].first).to have_key(:latLng)
    expect(denver[:results].first[:locations].first[:latLng]).to have_key(:lat)
    expect(denver[:results].first[:locations].first[:latLng]).to have_key(:lng)
    expect(denver[:results].first[:locations].first[:latLng][:lat]).to be_a(Float)
    expect(denver[:results].first[:locations].first[:latLng][:lng]).to be_a(Float)
  end

  it 'errors with no location', vcr: 'empty_geocode' do
    none = GeocodeService.geocode('')
    expect(none).to be_a(Hash)
    expect(none).to have_key(:info)
    expect(none[:info]).to have_key(:statuscode)
    expect(none[:info][:statuscode]).to eq(400)
    expect(none[:info][:messages]).to eq(['Illegal argument from request: Insufficient info for location'])
    expect(none[:results].first[:locations]).to be_empty
  end
end
