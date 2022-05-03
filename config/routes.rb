Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  root "home#index"
  
  get 'oauth2/callback', to: 'users/oauth_callbacks#github'
  get 'oauth2/revoke', to: 'users/oauth_callbacks#github_revoke'

  resources :courses, only: %i(index show new create destroy) do
    resources :assignments, only: %i(index show new create)
  end
end
