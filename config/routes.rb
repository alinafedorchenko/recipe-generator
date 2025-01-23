Rails.application.routes.draw do
  resources :recipes, only: [:create, :index]
  root "recipes#index"
end
