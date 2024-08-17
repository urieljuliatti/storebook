# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :users

  post 'login', to: 'authentication#login'
  resources :books, only: [:index, :show]

  resources :carts do
    member do
      post 'add_item'
      post 'remove_item'
    end
  end

  resources :orders, only: [:index, :show, :create]

  namespace :api do
    namespace :v1 do
      resources :books
      resources :authors
    end
  end
end
