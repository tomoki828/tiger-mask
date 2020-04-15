Rails.application.routes.draw do
  root "masks#index"
  resources :masks, only: [:show]
  resources :carts, only: [:show]

  post '/add_item' => 'carts#add_item'
  post '/update_item' => 'carts#update_item'
  delete '/delete_item' => 'carts#delete_item'
end
