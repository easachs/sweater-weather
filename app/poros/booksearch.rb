# frozen_string_literal: true

class Booksearch
  attr_reader :total_books_found, :books

  def initialize(data)
    @total_books_found = data[:numFound]
    @books = data[:docs].map do |book|
      {
        isbn: book[:isbn] || [],
        title: book[:title],
        publisher: book[:publisher] || []
      }
    end
  end
end
