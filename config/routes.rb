# frozen_string_literal: true

Rails.application.routes.draw do
  resources :registrations
  resources :endorsements, only: %i[create]
  resources :accounts, only: %i[index show update]
  resources :users, only: %i[index show update]
end
