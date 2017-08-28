Rails.application.routes.draw do

  ActiveAdmin.routes(self)
  mount Attachinary::Engine => "/attachinary"
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :libraries, only: [ :show, :new, :create, :edit, :update ] do
    resources :books, only: [ :new, :create ]
  end
  #   resources :reviews, only: [ :new, :create, :edit, :update ]
  # end

  # get '/books/new', to: 'books#book_new'
  resources :books, only: [ :index, :show, :new, :create, :edit, :update ] do
    resources :bookings, only: [ :show, :new, :create ] do
      # resources :reviews, only: [ :new, :create, :edit, :update ]
      resources :reviews, only: :create
    end
  end

  get '/profile', to: 'pages#profile'
end
