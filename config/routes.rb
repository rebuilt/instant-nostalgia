Rails.application.routes.draw do
  root to: 'photos#index'
  get 'photos/new', to: 'photos#new'
  scope '/:locale' do
    get 'photos/index'
    get 'photos/show'
    get 'photos/new'
  end
end
