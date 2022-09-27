# frozen_string_literal: true

class ApplicationController < ActionController::API
  def request_params
    JSON.parse(request.raw_post, symbolize_names: true) unless ['', nil].include?(request.raw_post)
  end
end
