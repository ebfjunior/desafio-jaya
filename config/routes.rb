Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "home#wishlist"

  resources :foursquare, only: [] do
    collection do
      get :callback

      post :authenticate
    end
  end

  resources :home, only: [:index] do
    collection do
      post :add_venue

      delete :remove_venue
    end
  end
end
