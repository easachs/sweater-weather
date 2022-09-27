# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Booksearch do
  it 'exists and has attributes', vcr: 'denver_books' do
    service = BookService.booksearch('Denver')
    denver = Booksearch.new(service)
    expect(denver).to be_a(Booksearch)
    expect(denver.total_books_found).to eq(8849)
    expect(denver.books).to be_a(Array)
    denver.books.each do |book|
      expect(book).to have_key(:isbn)
      expect(book[:isbn]).to be_a(Array)
      expect(book).to have_key(:title)
      expect(book[:title]).to be_a(String)
      expect(book).to have_key(:publisher)
      expect(book[:publisher]).to be_a(Array)
    end
  end

  it 'errors gracefully', vcr: 'book_empty_location' do
    none = BookFacade.booksearch('')
    expect(none).to be_a(Booksearch)
    expect(none.total_books_found).to eq(0)
    expect(none.books).to eq([])
  end
end
