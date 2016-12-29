Rails.application.routes.draw do
  resources :arguments
  resources :statements do
    member do
      get :new_response
    end
  end
  resources :premises, controller: :premises, only: [:index, :show]
end
