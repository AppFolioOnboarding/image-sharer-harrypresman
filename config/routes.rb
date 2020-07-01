Rails.application.routes.draw do
  root 'images#index'

  resources :images, only: %i[show create index new destroy]
end
