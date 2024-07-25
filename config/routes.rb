Rails.application.routes.draw do
  resources :users
  resources :articles
  resources :users, only: [:index]

  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'services', to: 'pages#services'
  get 'contact', to: 'pages#contact'
  
end
