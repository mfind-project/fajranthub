# frozen_string_literal: true

Rails.application.routes.draw do
  resources :fajrants
  resources :users
  get 'homepage/index'

  root 'homepage#index'
  resources :chb
end
