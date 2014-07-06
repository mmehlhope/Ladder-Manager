LadderManager::Application.routes.draw do

  devise_for :users, controllers: {registrations: "users/registrations"}
  resources :organizations

  scope "/admin" do
    resources :users
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
  get  '/release_notes', to: "release_notes#index"
  get  '/about', to: "about#index"
  post '/request_invite', to: "signups#create"

  # Home page
  root 'home#index'
  
  # 404 Matching
  match '*url', to: "errors#routing", via: :all
end
