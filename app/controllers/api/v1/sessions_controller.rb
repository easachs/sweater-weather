# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      def create
        user_params = JSON.parse(request.raw_post, symbolize_names: true) unless ['', nil].include?(request.raw_post)
        user_params ? user = User.find_by(email: user_params[:email]) : nil
        if !user_params
          render json: { error: 'missing JSON payload in request body' }, status: 400
        elsif user&.authenticate(user_params[:password])
          render json: UserSerializer.new_user_response(user)
        else
          render json: { error: 'invalid credentials' }, status: 401
        end
      end
    end
  end
end
