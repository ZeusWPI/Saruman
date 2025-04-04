Rails.application.routes.draw do
  # Devise
  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :users do
    member do
      get 'sign_in', to: 'sign_in#sign_in_partner'
    end
  end

  resources :partners do # Admin resources to display partners
    member do
      post :send_unsent_tokens
      post :send_barcode

      get :billing
      get :download_bill
      get :send_bill

      get :scan, as: :scan
      post :process_scan
    end

    collection do
      get :excel
    end

    resources :users do
      member do
        post :resend
      end
    end

    resources :reservations do
      member do
        post :approve
        get :revert
        get :history

        get :disapprove
        post :disapproved
      end

      collection do
        get :summary

        post :approve_all
      end
    end
  end

  resource :setting

  resources :items

  scope "/scan" do
    get 'scan', to: 'scan#scan'
    get 'list_partners', to: 'scan#list_partners'
    get 'list_items', to: 'scan#list_items'
    post 'check', to: 'scan#check'
    post 'force', to: 'scan#force'
  end

  resources :reports do
    collection do
      get :items
      get :partners
      get :item_barcodes
      get :partner_barcodes
    end
  end
end
