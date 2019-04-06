Rails.application.routes.draw do
  resources :users do
    resources :repositories, only: :index do
      resources :branches, only: :index
    end
    resources :issues, only: :index
  end
  resources :repositories
  resources :branches
  resources :pull_requests
  resources :issues
end
