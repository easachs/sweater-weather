# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GeocodeFacade do
  it 'creates poros', vcr: 'denver_geocode' do
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
end
