Rails.application.routes.draw do
  root to: 'photos#index'
  get 'photos/index'
  get 'photos/show'
  get 'photos/new'
end
