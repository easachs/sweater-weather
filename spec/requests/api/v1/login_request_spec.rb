# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login' do
  before :each do
    User.create!(email: 'e@g', password: 'test', password_confirmation: 'test')
  end

  it 'returns formatted response with api key' do
    params = {
      email: 'e@g',
      password: 'test'
    }

    post '/api/v1/sessions', params: params.to_json

    expect(response).to be_successful
    expect(response.status).to eq(200)
    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response).to have_key(:data)
    expect(parsed_response[:data]).to have_key(:type)
    expect(parsed_response[:data][:type]).to eq('users')
    expect(parsed_response[:data]).to have_key(:id)
    expect(parsed_response[:data][:id]).to be_a(Integer)
    expect(parsed_response[:data]).to have_key(:attributes)
    expect(parsed_response[:data][:attributes].keys.length).to eq(2)
    expect(parsed_response[:data][:attributes]).to have_key(:email)
    expect(parsed_response[:data][:attributes][:email]).to eq(User.last.email)
    expect(parsed_response[:data][:attributes]).to have_key(:api_key)
    expect(parsed_response[:data][:attributes][:api_key]).to be_a(String)
    expect(parsed_response[:data][:attributes]).to_not have_key(:password)
    expect(parsed_response[:data][:attributes]).to_not have_key(:password_confirmation)
    expect(parsed_response[:data][:attributes]).to_not have_key(:password_digest)
  end

  it 'errors when passwords dont match' do
    params = {
      'email': 'e@g',
      'password': 'test1'
    }

    post '/api/v1/sessions', params: params.to_json
    expect(response.status).to eq(400)
    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response).to eq({ error: 'invalid credentials' })
  end

  it 'errors when fields blank 1' do
    params = {
      'password': 'test'
    }

    post '/api/v1/sessions', params: params.to_json
    expect(response.status).to eq(400)
    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response).to eq({ error: 'invalid credentials' })
  end

  it 'errors when fields blank 2' do
    params = {
      'email': 'e@g'
    }

    post '/api/v1/sessions', params: params.to_json
    expect(response.status).to eq(400)
    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response).to eq({ error: 'invalid credentials' })
  end
end
