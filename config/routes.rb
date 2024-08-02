Rails.application.routes.draw do
  resources :articles
  resources :users, except: [:new] do
    member do
      patch :make_admin
      patch :remove_admin
    end
  end

  resources :categories

  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'services', to: 'pages#services'
  get 'contact', to: 'pages#contact'
  get 'signup', to: 'users#new'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
end
