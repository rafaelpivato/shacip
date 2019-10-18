# frozen_string_literal: true

Rails.application.routes.draw do
  resources :registrations
  resources :endorsements, only: %i[create]
  resources :organizations, only: %i[index show update] do
    resources :users, only: %i[index]
  end
  resources :users, only: %i[index show update] do
    resources :organizations, only: %i[index]
  end
end
