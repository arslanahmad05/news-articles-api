Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount_devise_token_auth_for 'User', at: 'auth'

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :users
      resources :topics
      resources :articles
      resources :authors
      resources :searches, only: [:index]
    end
  end
end
