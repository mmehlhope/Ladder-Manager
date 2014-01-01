RailsCompetitionPlatform::Application.routes.draw do
  resources :sessions, only: [:create, :destroy]
  resources :users

  # Ladder, competitors, matches, games
  resources :ladders, shallow: true do
    resources :competitors
    resources :matches do
      get 'finalize', on: :member

      resources :games
    end
  end

  # Custom routes
  post '/ladders/search', to: "ladders#search"
  get '/release_notes', to: "release_notes#index"

  # You can have the root of your site routed with "root"
  root 'home#index'
end
