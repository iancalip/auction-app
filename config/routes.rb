Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'home#index'
  resources :products, only: [:show, :new, :create, :edit, :update]
  resources :lots, only: [:new, :create, :show, :edit, :update] do
    patch 'approve_status', on: :member
    patch 'cancel_status', on: :member
    patch 'close_status', on: :member
    get 'expired_lots', on: :collection
    member do
      get :assign_products
      post :update_products
    end
    resources :bids, only: [:create]
  end
end
