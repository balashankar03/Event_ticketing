Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
   devise_scope :user do
    get "signup/organizer", to: "users/registrations#new" , as: :new_organizer_registration, type: "Organizer"
    get "signup/participant", to: "users/registrations#new" , as: :new_participant_registration, type: "Participant"
  end

  devise_for :users, controllers: {registrations: 'users/registrations'}

  root "events#index"
  get 'landing', to: 'landings#index', as: :landing
  
  resources :categories
  resources :venues
  resources :users
  resources :tickets
  resources :ticket_tiers
  resources :participants
  resources :organizers
  resources :orders
  resources :events do
    resources :ticket_tiers, only: [:index, :create, :update, :new]
    resources :bookings, only: [:create]
  end

  resources :participants do
    resources :orders, only: [:index, :show]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
