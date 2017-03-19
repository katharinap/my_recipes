# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :recipes
  root 'recipes#index'

  resources :users, only: [] do
    resource :authentication_token, only: %(update)
  end

  resources :ratings, only: :update
end
