Rails.application.routes.draw do
  root 'static_pages#top'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: %i[new create destroy]
  resources :voices
  resources :topics, only: %i[new create index show] do
    resources :answers, only: %i[new create show edit update destroy]
  end
  resource :mypage, only: %i[show edit update]
end
