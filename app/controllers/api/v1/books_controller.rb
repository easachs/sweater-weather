# frozen_string_literal: true

module Api
  module V1
    class BooksController < ApplicationController
      def index
        if ['', nil].include?(params[:location])
          render json: { error: 'location param required' }, status: 400
        else
          render json: BookSerializer.booksearch(params[:location], params[:quantity])
        end
      end
    end
  end
end
