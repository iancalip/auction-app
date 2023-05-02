Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'home#index'
  resources :products, only: [:show, :new, :create, :edit, :update]
end
