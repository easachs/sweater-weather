class Api::V1::BooksController < ApplicationController

  def index
    render json: BookSerializer.response_for(params[:location], params[:quantity])
  end
end