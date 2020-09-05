Rails.application.routes.draw do
  root to: 'welcome#index'
  get 'login', to: 'session#new'
  get 'signup', to: 'user#new'
  scope '/:locale' do
    resources :photos do
      resources :comments
    end
    resources :users
    resources :sessions, only: %i[new create destroy]
    resources :albums
    resources :photo_albums, only: %i[update destroy]
    resources :shares, only: %i[index new create]
  end
end
