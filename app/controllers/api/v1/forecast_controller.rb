# frozen_string_literal: true

module Api
  module V1
    class ForecastController < ApplicationController
      def index
        render json: WeatherSerializer.response_for(params[:location])
      end
    end
  end
end
