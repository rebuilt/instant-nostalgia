Rails.application.routes.draw do
  root to: 'welcom#index'
  get 'login', to: 'session#new'
  get 'signup', to: 'user#new'
  scope '/:locale' do
    resources :photos
    resources :users
    resources :sessions, only: %i[new create destroy]
  end
end
