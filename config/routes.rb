Saruman::Application.routes.draw do
  devise_for :partners

  devise_for :users, controllers: { sessions: 'sessions' }
  devise_scope :user do
    unauthenticated :user do
      root to: 'devise/sessions#new'
    end

    authenticated :user do
      root to: 'dashboard#show', as: :user_root
    end
  end

  concern :barcodes do
    get :barcodes, on: :collection
  end

  resources :categories
  resources :items,    concerns: :barcodes
  resources :partners, concerns: :barcodes
  resources :users

  namespace :psc do
    get '/sign_in/:token', controller: :partners, action: :token
  end

  # as :user do
    # get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    # put 'users' => 'devise/registrations#update', :as => 'user_registration'
  # end

  resources :users do # Admin resources to display partners
    member do
      get 'sign_in', to: 'sign_in#sign_in_partner'
      get :resend
      get :send_barcode
      get :get_barcode
      get :send_bill
      get :scan, as: :scan
      post :process_scan
    end

    resources :reservations do
      member do
        get :approve
        get :revert
      end
      collection do
        post :disapprove
        post :approve_all
      end
    end
  end

  resources :settings

  scope "/scan" do
    get 'scan', to: 'scan#scan'
    get 'list_partners', to: 'scan#list_partners'
    get 'list_items', to: 'scan#list_items'
    post 'check', to: 'scan#check'
    post 'force', to: 'scan#force'
  end

  get 'reservations', to: 'reservations#index'
end
