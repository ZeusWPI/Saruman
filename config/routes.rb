Saruman::Application.routes.draw do
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
    end

    resources :reservations do
      member do
        get :approve
      end
      collection do
        post :disapprove
      end
    end
  end

  resources :items
  get 'reservations/overview', to: 'reservations#overview'
end
