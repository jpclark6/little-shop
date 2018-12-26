Rails.application.routes.draw do
  root 'items#index'
  namespace :admin do
    resources :merchants, only: [:none], shallow: true do
      resources :items, expect: [:show]
    end
    patch 'items/toggle/:id', to: "items#toggle", as: "item_toggle", as: "item_toggle"
    get 'merchants/:id', to: "users#merchant_show", as: "merchant"
    get 'users/:id', to: "users#show", as: "user"
    get 'users', to: "users#index", as: "users"
    patch 'users/toggle/:id', to: "users#toggle", as: "toggle_user"
  end

  resources :items, only: [:show, :index]
  resources :carts, only: [:create]
  resources :users, only: [:index, :create, :edit]

  namespace :profile do
    get '', to: 'users#show'
    resources :orders, only: [:show, :destroy, :index, :create] do
      resources :order_items, only: [:update]
    end
    get '/edit', to: 'users#edit', as: "edit"
    patch '/update', to: 'users#update'
  end

  get '/cart', to: 'carts#show'
  patch '/cart', to: 'carts#update'
  delete '/cart', to: 'carts#delete'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :dashboard do
    get "", to: 'users#show'
    resources :items, except: [:show]
    resources :orders, only: [:show, :index]
    patch "/items/toggle/:id", to: "items#toggle", as: "item_toggle"
    patch "/orders/fulfill/:id", to: "orders#fulfill", as: "order_fulfill"
  end

  get '/register', to: 'users#new'
  get '/merchants', to: 'users#index'
  get '/merchants/:id', to: 'users#show'

  match '*a', :to => 'errors#not_found', via: :get

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
