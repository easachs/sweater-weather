# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookService do
  it 'returns response body', vcr: 'denver_books' do
    denver = BookService.booksearch('Denver', 5)
    expect(denver).to be_a(Hash)
    expect(denver).to have_key(:numFound)
    expect(denver).to have_key(:num_found)
    expect(denver).to have_key(:docs)
    expect(denver).to have_key(:q)
    expect(denver[:docs]).to be_a(Array)
    expect(denver[:docs].length).to eq(5)

    denver[:docs].each do |book|
      expect(book).to be_a(Hash)
      # expect(book).to have_key(:isbn)
      # expect(book[:isbn]).to be_a(Array)
      expect(book).to have_key(:title)
      expect(book[:title]).to be_a(String)
      expect(book).to have_key(:publisher)
      expect(book[:publisher]).to be_a(Array)
    end
  end

  it 'sad path no location', vcr: 'book_empty_location' do
    none = BookService.booksearch('')
    expect(none).to be_a(Hash)
    expect(none).to have_key(:numFound)
    expect(none).to have_key(:docs)
    expect(none[:docs]).to eq([])
    expect(none).to have_key(:error)
    expect(none[:error]).to eq('Received None response from run_solr_query')
  end
end
