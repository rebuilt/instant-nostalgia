Rails.application.routes.draw do
  root to: 'photos#index'
  scope '/:locale' do
    resources :photos
  end
end
