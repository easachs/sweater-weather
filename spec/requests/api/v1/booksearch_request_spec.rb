# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Book search' do
  it 'returns formatted book search', vcr: 'denver_books_and_weather' do
    get '/api/v1/book-search?location=Denver&quantity=5'
    expect(response).to be_successful
    denver = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(denver).to have_key(:attributes)
    expect(denver[:attributes]).to have_key(:destination)
    expect(denver[:attributes][:destination]).to eq('Denver')
    expect(denver[:attributes]).to have_key(:forecast)
    expect(denver[:attributes][:forecast]).to be_a(Hash)
    expect(denver[:attributes][:forecast]).to have_key(:summary)
    expect(denver[:attributes][:forecast][:summary]).to be_a(String)
    expect(denver[:attributes][:forecast]).to have_key(:temperature)
    expect(denver[:attributes][:forecast][:temperature]).to be_a(String)

    expect(denver[:attributes]).to have_key(:total_books_found)
    expect(denver[:attributes][:total_books_found]).to be_a(Integer)

    expect(denver[:attributes]).to have_key(:books)
    expect(denver[:attributes][:books]).to be_a(Array)
    expect(denver[:attributes][:books].length).to eq(5)
    denver[:attributes][:books].each do |book|
      expect(book).to have_key(:isbn)
      expect(book[:isbn]).to be_a(Array)
      expect(book).to have_key(:title)
      expect(book[:title]).to be_a(String)
      expect(book).to have_key(:publisher)
      expect(book[:publisher]).to be_a(Array)
    end
  end

  it 'errors gracefully' do
    get '/api/v1/book-search?location='
    none = JSON.parse(response.body, symbolize_names: true)

    expect(none).to be_a(Hash)
    expect(none).to have_key(:error)
    expect(none.keys.length).to eq(1)
    expect(none[:error]).to eq('location param required')

    get '/api/v1/book-search'
    none = JSON.parse(response.body, symbolize_names: true)

    expect(none).to be_a(Hash)
    expect(none).to have_key(:error)
    expect(none.keys.length).to eq(1)
    expect(none[:error]).to eq('location param required')
  end

  it 'errors gracefully with invalid limit' do
    get '/api/v1/book-search?location=Denver&quantity=none'
    none = JSON.parse(response.body, symbolize_names: true)

    expect(none).to be_a(Hash)
    expect(none).to have_key(:error)
    expect(none.keys.length).to eq(1)
    expect(none[:error]).to eq('invalid limit')
  end
end
