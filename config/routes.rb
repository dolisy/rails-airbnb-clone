Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :libraries, only: [ :show, :new, :create ] do
    resources :reviews, only: [ :show, :new, :create ]
  end

  resources :books, only: [ :index, :show, :new, :create, :edit, :update ] do
    resources :bookings, only: [ :show, :new, :create ] do
      resources :reviews, only: [ :show, :new, :create ]
    end
  end

  get '/profile', to: 'pages#profile'
end
