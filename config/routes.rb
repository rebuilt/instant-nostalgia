Rails.application.routes.draw do
  root to: 'photos#index'
  get 'photos/new', to: 'photos#new'
  scope '/:locale' do
    resources :photos
  end
end
