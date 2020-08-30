Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  get 'users/new'
  get 'users/edit'
  root to: 'photos#index'
  scope '/:locale' do
    resources :photos
  end
end
