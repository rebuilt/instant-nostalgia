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
    resources :albums, only: %i[index show create update destroy] do
      post :toggle_public
    end
    resources :photo_albums, only: %i[update destroy]
    resources :shares, only: %i[index new create]
    resources :maps, only: %i[index]
    resources :public_albums, only: %i[index]
  end
end
