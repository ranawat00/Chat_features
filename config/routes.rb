Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  namespace :api do
    post 'sign_up', to: 'authentications#sign_up'
    post 'log_in', to: 'authentications#login'

    resources :external_members do
      get 'external_chats/search', to: 'external_chats#search'
      post 'external_chats/start_chat', to: 'external_chats#start_chat', on: :collection
      resources :invitations, only: [:create,:accept]
    end

    get 'invitations/:token/accept', to: 'invitations#accept', as: 'accept_invitation'
    resources :conversations do
      resources :messages
    end
  end
end
