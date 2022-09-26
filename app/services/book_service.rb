# frozen_string_literal: true

class BookService
  def self.booksearch(location, quantity)
    response = conn.get('search.json') do |f|
      f.params['place'] = location
      f.params['limit'] = quantity
    end
    parse_json(response)
  end

  def self.conn
    Faraday.new(url: 'http://openlibrary.org') do |f|
      f.params['key'] = ENV['map_key']
    end
  end

  def self.parse_json(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
