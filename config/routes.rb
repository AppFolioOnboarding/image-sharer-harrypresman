Rails.application.routes.draw do
  root 'images#index'

  resources :images, only: %i[show create index new destroy edit update]
  resources :feedbacks, only: [:new]

  namespace :api do
    resource :feedbacks, only: [:create]
  end
end
