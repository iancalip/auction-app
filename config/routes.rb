Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'home#index'
  resources :products, only: [:show, :new, :create, :edit, :update, :index]
  resources :lots, only: [:new, :create, :show, :edit, :update, :index] do
    patch 'approve_status', on: :member
    patch 'cancel_status', on: :member
    patch 'close_status', on: :member
    get 'expired', on: :collection
    member do
      get :assign_products
      post :update_products
    end
    resources :bids, only: [:create]
  end
end
