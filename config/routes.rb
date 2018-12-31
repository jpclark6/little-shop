Rails.application.routes.draw do
  root 'items#index'

  get '/register', to: 'users#new'
  get '/merchants', to: 'users#index'
  get '/merchants/:id', to: 'users#show'

  get '/cart', to: 'carts#show', as: 'cart'
  patch '/cart', to: 'carts#update'
  delete '/cart', to: 'carts#delete'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :items, only: [:show, :index]
  resources :carts, only: [:create]
  resources :users, only: [:index, :create, :edit]

  namespace :profile do
    get '', to: 'users#show'
    resources :orders, only: [:show, :destroy, :index, :create]
    get '/edit', to: 'users#edit', as: "edit"
    patch '/update', to: 'users#update'
  end

  namespace :dashboard do
    get "", to: 'users#show'
    resources :items, except: [:show]
    resources :orders, only: [:show, :index]
    patch "/items/toggle/:id", to: "items#toggle", as: "item_toggle"
    patch "/order_items/fulfill/:id", to: "order_items#fulfill", as: "order_item_fulfill"
  end

  namespace :admin do
    resources :merchants, only: [:none], shallow: true do
      resources :items, except: [:show]
    end
    resources :users, only: [:show, :index, :edit, :update]
    resources :orders, only: [:show, :destroy]
    patch 'items/toggle/:id', to: "items#toggle", as: "item_toggle"
    patch 'users/toggle/:id', to: "users#toggle", as: "toggle_user"
    patch 'users/upgrade/:id', to: "users#upgrade", as: "user_upgrade"
    patch 'users/downgrade/:id', to: "users#downgrade", as: "merchant_downgrade"
    get 'merchants/:id', to: "users#merchant_show", as: "merchant"
    patch "/order_items/fulfill/:id", to: "order_items#fulfill", as: "order_item_fulfill"
  end

  match '*a', :to => 'errors#not_found', via: :get

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
