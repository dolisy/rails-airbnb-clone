Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :libraries, only: [ :show, :new, :create ] do
    resources :reviews, only: [ :show, :new, :create ]
  end

  resources :books, only: [ :index, :show, :new, :create ] do
    resources :bookings, only: [ :show, :new, :create ] do
      resources :reviews, only: [ :show, :new, :create ]
    end
  end

  get '/profile', to: 'pages#profile'
end
