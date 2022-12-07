Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do 
    namespace :v1 do 
      resources :merchants do 
      end

      resources :items 
      get "merchants/:id/items", to: "merchant_items#index"
      get "/items/:id/merchant", to: "merchant_items#show"

    end
  end
end
