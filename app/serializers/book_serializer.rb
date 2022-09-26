# frozen_string_literal: true

class BookSerializer
  def self.booksearch(location, limit = 5)
    books = BookFacade.booksearch(location, limit)
    weather = WeatherFacade.forecast(location)
    if ['', nil].include?(location)
      { error: 'location param required' }
    else
      {
        data: {
          id: nil,
          type: 'books',
          attributes: {
            destination: location,
            forecast: {
              summary: weather.current_weather[:conditions],
              temperature: "#{weather.current_weather[:temperature]} F"
            },
            total_books_found: books.total_books_found,
            books: books.books.map do |book|
              {
                isbn: book[:isbn],
                title: book[:title],
                publisher: book[:publisher]
              }
            end
          }
        }
      }
    end
  end
end
