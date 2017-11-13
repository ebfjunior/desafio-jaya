Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "home#index"

  resources :foursquare, only: [] do
    collection do
      post :authenticate
      get :callback
    end
  end
end
