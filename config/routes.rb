Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  get 'oauth2/callback', to: 'users/oauth_callbacks#github'
  root "home#index"
end
