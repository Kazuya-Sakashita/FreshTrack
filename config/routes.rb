Rails.application.routes.draw do
  devise_for :users
  root to: 'products#index'
  resources :products do
    member do
      patch :toggle_notify_expiration
    end

    collection do
      post :test_notification
    end
  end

  resource :job_schedule, only: %i[new create edit update show]
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
