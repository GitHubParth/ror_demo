Rails.application.routes.draw do
  resources :articles
  resources :users, except: [:new]

  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'services', to: 'pages#services'
  get 'contact', to: 'pages#contact'
  get 'signup', to: 'users#new'
  
end
