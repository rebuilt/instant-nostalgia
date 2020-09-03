Rails.application.routes.draw do
  get 'albums/index'
  root to: 'welcome#index'
  get 'login', to: 'session#new'
  get 'signup', to: 'user#new'
  scope '/:locale' do
    resources :photos
    resources :users
    resources :sessions, only: %i[new create destroy]
    resources :albums
    resources :photo_albums, only: %i[update destroy]
  end
end
