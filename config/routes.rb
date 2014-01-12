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

  #################
  # Custom routes #
  #################
  get  '/ladders/:id/admin_preferences', to: "ladders#admin_preferences", as: :admin_preferences
  post '/ladders/search', to: "ladders#search"
  get  '/release_notes', to: "release_notes#index"
  get  '/login', to: "users#login"

  # Home page
  root 'home#index'
end
