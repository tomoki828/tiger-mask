Rails.application.routes.draw do
  root "masks#index"
  resources :masks, only: :show
end
