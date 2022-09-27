# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookSerializer do
  it 'responds with formatted hash', vcr: 'denver_books_serializer' do
    denver = BookSerializer.booksearch('Denver')[:data]
    expect(denver).to be_a(Hash)
    expect(denver[:id]).to be_nil
    expect(denver[:type]).to eq('books')
    expect(denver).to have_key(:attributes)
    expect(denver[:attributes]).to be_a(Hash)

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
    none = BookSerializer.booksearch('')
    expect(none).to be_a(Hash)
    expect(none).to have_key(:error)
    expect(none.keys.length).to eq(1)
    expect(none[:error]).to eq('location param required')
  end

  it 'errors gracefully with invalid limit' do
    none = BookSerializer.booksearch('Denver', -2)
    expect(none).to be_a(Hash)
    expect(none).to have_key(:error)
    expect(none.keys.length).to eq(1)
    expect(none[:error]).to eq('invalid limit')
  end
end
