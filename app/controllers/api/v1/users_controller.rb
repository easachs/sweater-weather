# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.create(request_params) if request_params
        if !request_params
          render json: { error: 'missing JSON payload in request body' }, status: 400
        elsif user.save
          render json: UserSerializer.new_user_response(user), status: :created
        else
          render json: { error: user.errors.full_messages * ', ' }, status: 400
        end
      end
    end
  end
end
