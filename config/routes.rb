Rails.application.routes.draw do

  devise_for :users

  post 'login', to: 'authentication#login'
  resources :books, only: [:index, :show]

  resources :carts, only: [:show, :create] do
    post 'add_item/:book_id', to: 'carts#add_item', as: 'add_item'
    delete 'remove_item/:book_id', to: 'carts#remove_item', as: 'remove_item'
  end
  resources :orders, only: [:index, :show, :create]

  namespace :api do
    namespace :v1 do
      resources :books
      resources :authors
    end
  end
end
