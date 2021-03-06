Rails.application.routes.draw do

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :users do
    get '/attendances', to: 'users#attendances'
    resources :attendances, only: [:create, :edit, :update, :destroy]
  end

  mount Base => '/api'

end
