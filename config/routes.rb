Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  namespace :api do
    post 'sign_up', to: 'authentications#sign_up'
    post 'log_in', to: 'authentications#login'
    resources :conversations do
      resources :messages
    end
  end
  
end
