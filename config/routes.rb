Rails.application.routes.draw do
  resources :authors
  namespace :api do
    namespace :v1 do
      resources :books
    end
  end
end
