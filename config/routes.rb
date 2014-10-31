MyLittleBlackjack::Application.routes.draw do
  root :to => "sessions#new"

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"

  resources :users do
    member do
      get 'stats'
    end
  end

  resources :sessions

  resources :blackjacks do
    member do
      get 'show'
      post 'show'
      post 'hit'
      post 'stand'
    end
  end
end
