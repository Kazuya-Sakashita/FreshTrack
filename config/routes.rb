Rails.application.routes.draw do
  devise_for :users
  root to: 'products#index'
  resources :products

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
