Rails.application.routes.draw do
  namespace :backoffice do
    namespace :v1 do
      resources :companies
      resources :users, only: [:index, :create, :destroy]
    end
  end
end
