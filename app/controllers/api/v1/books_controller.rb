class Api::V1::BooksController < ApplicationController

  def index
    if ['', nil].include?(params[:location])
      render json: { error: 'location params required' }, status: 400
    else
      render json: BookSerializer.response_for(params[:location], params[:quantity])
    end
  end
end