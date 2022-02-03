Rails.application.routes.draw do
  resources :game_sessions, only: [:index, :create, :update, :destroy, :show]

  resources :broadcasters, only: [:index, :show, :create, :update]
  resources :grimoires

  root "home#index"
end
