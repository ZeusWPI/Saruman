Rails.application.routes.draw do
  # Devise
  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :users do # Admin resources to display partners
    member do
      get 'sign_in', to: 'sign_in#sign_in_partner'
      get :resend
      get :send_barcode
      get :get_barcode

      get :download_bill
      get :send_bill

      get :scan, as: :scan
      post :process_scan
    end

    collection do
      post :excel
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
  resources :items

  scope "/scan" do
    get 'scan', to: 'scan#scan'
    get 'list_partners', to: 'scan#list_partners'
    get 'list_items', to: 'scan#list_items'
    post 'check', to: 'scan#check'
    post 'force', to: 'scan#force'
  end

  get 'reservations', to: 'reservations#index'
end
