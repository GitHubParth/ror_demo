Rails.application.routes.draw do
  resources :articles, only: [:show]
  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'services', to: 'pages#services'
  get 'contact', to: 'pages#contact'
  
end
