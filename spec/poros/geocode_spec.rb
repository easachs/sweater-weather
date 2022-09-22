# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Geocode do
  it 'exists and has attributes', vcr: 'denver_geocode' do
    service = GeocodeService.geocode('Denver,CO')
    denver = Geocode.new(service)
    expect(denver).to be_a(Geocode)
    expect(denver.lat).to eq(39.738453)
    expect(denver.lng).to eq(-104.984853)
  end

  it 'errors gracefully', vcr: 'empty_geocode' do
    none_service = GeocodeService.geocode('')
    none = Geocode.new(none_service)
    expect(none.lat).to be_nil
    expect(none.lng).to be_nil
  end
end
