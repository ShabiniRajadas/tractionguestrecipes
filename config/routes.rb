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
        delete :logout, on: :collection
      end
      resources :categories
      resources :ingredients
      resources :recipes do
        put :upload_photo, on: :member
      end
    end
  end
end
