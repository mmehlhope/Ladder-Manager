LadderManager::Application.routes.draw do

  devise_for :users, controllers: {registrations: "users/registrations"}
  resources :organizations

  scope "/admin" do
    resources :users, only: [:index, :show, :update]
  end

  # Ladder, competitors, matches, games
  resources :ladders, shallow: true do
    resources :competitors
    resources :matches do
      post 'finalize', on: :member
      resources :games
    end
  end

  #################
  # Custom routes #
  #################
  post '/ladders/search', to: "ladders#search"
  get  '/release_notes', to: "release_notes#index"

  # Home page
  root 'home#index'
end
