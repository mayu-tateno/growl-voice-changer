Rails.application.routes.draw do
  namespace :supervisor do
    resources :topics
    resources :voices
    resources :answers
    resources :users
    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    get '/logout', to: 'sessions#logout'

    root to: 'sessions#new'
  end
  root 'static_pages#top'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  get '/privacy_policy', to: 'static_pages#privacy_policy'
  get '/terms', to: 'static_pages#terms'
  get '/inquiry', to: 'static_pages#inquiry'

  resources :users, only: %i[new create destroy]
  resources :voices
  resources :topics, only: %i[new create index show] do
    resources :answers, only: %i[new create show edit update destroy]
  end
  resource :mypage, only: %i[show edit update]
end
