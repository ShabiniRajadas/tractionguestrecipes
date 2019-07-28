Rails.application.routes.draw do
  namespace :backoffice do
    namespace :v1 do
      resources :companies
    end
  end
end
