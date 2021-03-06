Rails.application.routes.draw do

  # Handle OPTIONS preflight requests
  # Credit to jpbalarini https://gist.github.com/jpbalarini/54a1aa22ebb261af9d8bfd9a24e811f0
  match "*all", controller: "application", action: "cors_preflight_check", via: [:options]

  namespace :api do
    namespace :v1 do
      resources :game_sessions, only: [:index, :create]

      resources :broadcasters, only: [:index, :show, :create]
      resources :grimoires, only: [:index, :show, :create]
      
      get "sessions", to: "game_sessions#show"
      post "sessions", to: "game_sessions#create"
    end
  end

  get "/setup", to: "home#index"

  namespace :legal do
    get "/privacy-policy", to: "legal#privacy"
  end
  
  root "home#index"
end
