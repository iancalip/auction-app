Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'home#index'
  get 'search', to: 'home#search'
  resources :products, only: [:show, :new, :create, :edit, :update, :index]
  resources :lots, only: [:new, :create, :show, :edit, :update, :index] do
    member do
      get :assign_products
      post :update_products
      patch :close_status
      patch :cancel_status
      patch :approve_status
    end
    get 'expired', on: :collection
    resources :bids, only: [:create]
    resources :questions, only: [:create, :update] do
      resources :answers, only: [:create]
    end
  end
end
