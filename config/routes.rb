Rails.application.routes.draw do
  root 'static_pages#top'

  resources :users, only: %i[new create]
end
