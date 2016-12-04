Rails.application.routes.draw do
  resources :statements do
    member do
      get :new_response
    end
  end
end
