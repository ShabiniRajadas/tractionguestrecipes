require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'
  namespace :backoffice do
    namespace :v1 do
      resources :companies
      resources :users, only: %i[index create destroy]
    end
  end

  namespace :api do
    namespace :v1 do
      resource :auth, controller: :authentication do
        post :login, on: :collection
      end
      resources :categories
      resources :ingredients
      resources :recipes
    end
  end
end
