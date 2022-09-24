# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      def create
        user_params = JSON.parse(request.raw_post, symbolize_names: true)
        user = User.find_by(email: user_params[:email])
        if user&.authenticate(user_params[:password])
          session[:user_id] = user.id
          render json: UserSerializer.new_user_response(user)
        else
          render json: { error: 'invalid credentials' }, status: 400
        end
      end
    end
  end
end
