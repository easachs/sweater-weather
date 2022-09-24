# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSerializer do
  it 'formats a user' do
    user = User.create(email: 'e@g', password: 'test', password_confirmation: 'test')
    serializer = UserSerializer.new_user_response(user)
    expect(serializer).to be_a(Hash)
    expect(serializer.keys.length).to eq(1)
    expect(serializer).to have_key(:data)
    expect(serializer[:data].keys.length).to eq(3)
    expect(serializer[:data]).to have_key(:type)
    expect(serializer[:data]).to have_key(:id)
    expect(serializer[:data]).to have_key(:attributes)
    expect(serializer[:data][:attributes].keys.length).to eq(2)
    expect(serializer[:data][:attributes]).to have_key(:email)
    expect(serializer[:data][:attributes]).to have_key(:api_key)
  end
end
