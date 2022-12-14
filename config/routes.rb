# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :forecast, only: %i[index]
      resources :users, only: %i[create]
      resources :sessions, only: %i[create]
      resources :roadtrip, path: 'road_trip', only: %i[create]
      resources :books, path: 'book-search', only: %i[index]
    end
  end
end
