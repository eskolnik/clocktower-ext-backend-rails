Rails.application.routes.draw do

  # Handle OPTIONS preflight requests
  # Credit to jpbalarini https://gist.github.com/jpbalarini/54a1aa22ebb261af9d8bfd9a24e811f0
  match "*all", controller: "application", action: "cors_preflight_check", via: [:options]

  resources :game_sessions, only: [:index, :create, :update, :destroy, :show]

  resources :broadcasters, only: [:index, :show, :create, :update]
  resources :grimoires

  get "sessions", to: "game_sessions#show"
  post "sessions", to: "game_sessions#create"

  root "home#index"
end
