# frozen_string_literal: true

class BookFacade
  def self.booksearch(location, limit = 5)
    service = BookService.booksearch(location, limit)
    Book.new(service)
  end
end
