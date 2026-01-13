Rails.application.routes.draw do
  namespace :participant do
    get "dashboards/show"
  end
  namespace :organizer do
    get "dashboards/show"
  end
  use_doorkeeper
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
   devise_scope :user do
    get "signup/organizer", to: "users/registrations#new" , as: :new_organizer_registration, type: "Organizer"
    get "signup/participant", to: "users/registrations#new" , as: :new_participant_registration, type: "Participant"
  end

  devise_for :users, controllers: {registrations: 'users/registrations'}

  root "events#index"
  get 'landing', to: 'landings#index', as: :landing

  namespace :api do
    get 'users/me', to: 'users#me'
    patch 'users/me', to: 'users#update'
    delete 'users/me', to: 'users#destroy'
    get "events/:id/attendees", to: 'events#attendees'
    get "events/upcoming", to: "events#upcoming"
    get "/my-tickets", to: "orders#mytickets"

    #POST /orders/{id}/cancel
    #GET /events/{id}/availability
    get "venues/:venue_id/events", to: "venues#eventlist"
    resources :events
    resources :venues
    resources :organizers
    resources :participants
    resources :orders
  end

  namespace :organizer do
    resources :dashboards
  end
  namespace :participant do
    resources :dashboards
  end

  
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

  get 'login', to: "api_logins#new", as: :api_login
  post "login", to: "api_logins#create"
  delete "login", to: "api_logins#destroy", as: :api_logout

  


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
