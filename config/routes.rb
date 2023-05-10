Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'home#index'
  resources :products, only: [:show, :new, :create, :edit, :update]
  resources :lots, only: [:new, :create, :show, :edit, :update] do
    patch 'update_status', on: :member
    member do
      get :assign_products
      post :update_products
    end
  end
end
