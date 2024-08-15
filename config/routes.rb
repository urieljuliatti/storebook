Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :books
      resources :authors
    end
  end
end
