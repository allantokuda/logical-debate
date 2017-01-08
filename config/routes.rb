Rails.application.routes.draw do
	devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'public#landing'
  resources :arguments do
    member do
      post :publish
      post :upvote
      post :remove_vote
      get :suggest_new
      get :counter
    end
  end

  resources :statements do
    member do
      get :new_response
      post :agree
      post :disagree
      post :no_stance
      get :agreements
      get :disagreements
    end
  end
  resources :premises, controller: :premises, only: [:index, :show] do
    member do
      get :agree
      get :disagree
    end
  end
end
