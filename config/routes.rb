Rails.application.routes.draw do
  root 'items#index'
  namespace :admin do
    get 'merchants/:id', to: "users#show", as: "merchant"
    get 'users/:id', to: "users#show", as: "user"
    get 'users', to: "users#index", as: "users"

    put 'disable_user/:id', to: "users#disable", as: "disable_user"
    put 'enable_user/:id', to: "users#enable", as: "enable_user"
  end
  resources :items
  resources :carts, only: [:create]

  resources :users, only: [:index, :create, :edit] do
    # resources :orders, only: [:index]
  end


  get '/profile', to: 'users#show'
  get '/profile/orders', to: 'orders#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/dashboard', to: 'users#show'
  get '/dashboard/items', to: 'users#index'

  get '/register', to: 'users#new'
  get '/merchants', to: 'users#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
