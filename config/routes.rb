Rails.application.routes.draw do
	devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'statements#index'
  resources :arguments do
    member do
      post :publish
    end
  end

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
