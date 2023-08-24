Rails.application.routes.draw do
  devise_for :users
  root to: 'products#index'
  resources :products do
    member do
      patch :toggle_notify_expiration
    end
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end

