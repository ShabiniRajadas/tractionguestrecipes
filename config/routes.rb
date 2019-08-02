Rails.application.routes.draw do
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
    end
  end
end
