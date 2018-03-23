Rails.application.routes.draw do
  
  root 'restaurants#index'

  devise_for :users

  resources :users, only: [:index, :show]

  # Using the resources helper on line 7 is equivalent to:
  # get 'users', to: 'users#index', as: 'users'
  # get 'users/:id', to: 'users#show', as: 'user'

  get 'restaurants/:id', to: 'restaurants#show', as: 'restaurant'
  post 'restaurants/:id', to: 'restaurants#create_review', as: 'create_review'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
