# frozen_string_literal: true

module Api
  module V1
    class RoadtripController < ApplicationController
      def create
        roadtrip_params = JSON.parse(request.raw_post, symbolize_names: true)
        user = User.find_by(api_key: roadtrip_params[:api_key])
        if !(roadtrip_params[:origin] && roadtrip_params[:destination])
          render json: { error: 'you must include origin and destination' }, status: 400
        elsif user
          render json: RoadtripSerializer.roadtrip(roadtrip_params[:origin], roadtrip_params[:destination])
        else
          render json: { error: 'invalid credentials' }, status: 401
        end
      end
    end
  end
end
