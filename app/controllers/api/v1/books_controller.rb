# frozen_string_literal: true

module Api
  module V1
    class BooksController < ApplicationController
      def index
        render json: BookSerializer.booksearch(params[:location], params[:quantity] = 5)
      end
    end
  end
end
