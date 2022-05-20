Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  root "home#index"
  
  get 'oauth2/callback', to: 'users/oauth_callbacks#github'
  get 'oauth2/revoke', to: 'users/oauth_callbacks#github_revoke'

  resources :courses, only: %i(index show new create destroy) do
    get 'reports', to: 'reports#course_reports'

    resources :assignments, only: %i(index show new create) do
      get 'report', to: 'reports#show'
      get 'report/new', to: 'reports#new'
      post 'report/create', to: 'reports#create'
    end
  end
end
