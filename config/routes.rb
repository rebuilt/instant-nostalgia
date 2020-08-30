Rails.application.routes.draw do
  get 'sessions/index'
  root to: 'photos#index'
  scope '/:locale' do
    resources :photos
    resources :users
  end
end
