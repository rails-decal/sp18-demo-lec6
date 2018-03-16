Rails.application.routes.draw do
  
  devise_for :users
  get 'users', to: 'users#index', as: 'users'
  get 'users/:id', to: 'users#show', as: 'user'

  root 'restaurants#index'
  get 'restaurants/:id', to: 'restaurants#show', as: 'restaurant'
  post 'restaurants/:id', to: 'restaurants#create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
