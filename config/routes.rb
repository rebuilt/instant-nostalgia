Rails.application.routes.draw do
  root to: 'welcome#index'
  get 'login', to: 'sessions#new'
  get 'signup', to: 'user#new'
  scope '/:locale' do
    get 'photos/delete', to: 'photos#delete'
    resources :photos, only: %i[index show new create destroy] do
      resources :comments, only: %i[create destroy]
    end
    resources :users, only: %i[show new create edit update destroy]
    resources :sessions, only: %i[new create destroy]
    resources :albums, only: %i[index show create destroy] do
      post :toggle_public
    end
    resources :photo_albums, only: %i[update destroy]
    resources :shares, only: %i[index new create destroy]
    resources :maps, only: %i[index]
    resources :public_albums, only: %i[index]
    resources :photo_uploads, only: %i[create]
  end
end
