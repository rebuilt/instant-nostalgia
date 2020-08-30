Rails.application.routes.draw do
  get 'sessions/index'
  root to: 'photos#index'
  scope '/:locale' do
    resources :photos
    resources :users
    resources :sessions, only: %i[new create destroy]
  end
end
