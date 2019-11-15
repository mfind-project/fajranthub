# frozen_string_literal: true

Rails.application.routes.draw do
  resources :fajrants
  resources :users
  root 'homepage#index'
  post 'users', to: 'users#create'

  get 'users', to: 'users#new'
  resources :chb, format: :json
end
