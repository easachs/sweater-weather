# frozen_string_literal: true

module Api
  module V1
    class RoadtripController < ApplicationController
      def create
        user = User.find_by(api_key: request_params[:api_key]) unless !request_params
        if !request_params
          render json: { error: 'missing JSON payload in request body' }, status: 400
        elsif !(request_params[:origin] && request_params[:destination])
          render json: { error: 'you must include origin and destination' }, status: 400
        elsif user
          render json: RoadtripSerializer.roadtrip(request_params[:origin], request_params[:destination])
        else
          render json: { error: 'invalid credentials' }, status: 401
        end
      end
    end
  end
end
