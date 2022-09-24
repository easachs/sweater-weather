# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      def create
        user_params = JSON.parse(request.raw_post)
        user = User.create!(user_params)
        if user.save
          render json: UserSerializer.new_user_response(user), status: :created
        else
          render json: { error: user.errors.full_messages * ', ' }, status: 400
        end
      end
    end
  end
end
