Rails.application.routes.draw do

  devise_for :users

  post 'login', to: 'authentication#login'
  get '/books/:id', to: 'books#show', as: 'book'

  namespace :api do
    namespace :v1 do
      resources :books
      resources :authors
    end
  end
end
