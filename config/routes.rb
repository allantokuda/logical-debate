Rails.application.routes.draw do
  resources :arguments
  resources :statements do
    member do
      get :new_response
    end
  end
  resources :premises, controller: :premises, only: [:index, :show] do
    member do
      get :agree
      get :disagree
    end
  end
end
