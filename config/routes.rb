Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  root "home#index"
  get 'oauth2/callback', to: 'users/oauth_callbacks#github'

  resources :courses, only: %i(index show new create destroy)
end
