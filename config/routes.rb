require 'api_constraints.rb'

Rails.application.routes.draw do
  devise_for :users
  # Api definition
  namespace :api, defaults: { format: :json},
                              constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1,
              constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, :only => [:show, :create, :update, :destroy]
      resources :sessions, :only => [:create, :destroy]

      # Session Routes
      post '/sessions/signup', to: 'sessions#signup'
      post '/sessions/reset_password', to: 'sessions#reset_password'
    end
  end
end