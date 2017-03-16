Rails.application.routes.draw do
	devise_for :users, controllers: {
    registrations: 'registrations',
    confirmations: 'confirmations'
  }
  root 'statements#index'

  post :accept_agreement, controller: 'application'

  devise_scope :user do
    get 'users/confirmation_sent', to: 'confirmations#confirmation_sent', as: 'confirmation_sent'
  end

  resources :arguments do
    member do
      post :publish
      post :upvote
      post :remove_vote
      get :suggest_new
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
      post :review_arguments
    end
  end

  get 'arguments/:id/counter', to: 'counters#new', as: 'new_counter_argument'
  post 'arguments/:id/counter', to: 'counters#create', as: 'create_counter_argument'
end
