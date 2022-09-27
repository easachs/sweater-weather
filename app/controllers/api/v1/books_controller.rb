# frozen_string_literal: true

module Api
  module V1
    class BooksController < ApplicationController
      def index
        if params[:quantity]
          render json: BookSerializer.booksearch(params[:location], params[:quantity])
        else
          render json: BookSerializer.booksearch(params[:location])
        end
      end
    end
  end
end
