Saruman::Application.routes.draw do
  # Devise
  devise_for :partners
  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :partners do # Admin resources to display partners
    member do
      get :resend
    end

    resources :reservations
  end

  resources :items
end
