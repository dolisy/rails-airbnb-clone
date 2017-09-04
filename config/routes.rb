Rails.application.routes.draw do

  ActiveAdmin.routes(self)
  mount Attachinary::Engine => "/attachinary"
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :libraries, only: [ :show, :new, :create, :edit, :update ] do
    resources :books, only: [ :new, :create, :show ]
  end
  #   resources :reviews, only: [ :new, :create, :edit, :update ]
  # end

  # get '/books/new', to: 'books#book_new'
  resources :books, only: [ :index, :show, :new, :create, :edit, :update ] do
    resources :bookings, only: [ :show, :new, :create ]
      # resources :reviews, only: [ :new, :create, :edit, :update ]
  end

  resources :bookings, only: [] do
    member do
      patch "confirm", to: "bookings#confirm"
      patch "decline", to: "bookings#decline"
      patch "pending", to: "bookings#pending"
    end
  end

  resources :reviews, only: :create

  resources :conversations do
    resources :private_messages
  end

  get '/profile', to: 'pages#profile'
  get '/view_all_books', to: 'pages#view_all_books'
  get '/view_all_libraries', to: 'pages#view_all_libraries'
end
