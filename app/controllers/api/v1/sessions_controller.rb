# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      def create
        user = User.find_by(email: request_params[:email]) if request_params
        if !request_params
          render json: { error: 'missing JSON payload in request body' }, status: 400
        elsif user&.authenticate(request_params[:password])
          render json: UserSerializer.new_user_response(user)
        else
          render json: { error: 'invalid credentials' }, status: 401
        end
      end
    end
  end
end
