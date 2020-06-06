Rails.application.routes.draw do
  devise_for :users
  root "masks#index"
  resources :masks, only: [:show]
  resources :users, only: [:index]
  resources :cards, only: [:new, :create, :show, :destroy]
  
  resources :carts, only: [:index, :show] do
    collection do
      get 'purchase'
      get 'payment'
    end
  end

  post '/add_item' => 'carts#add_item'
  post '/update_item' => 'carts#update_item'
  delete '/delete_item' => 'carts#delete_item'
end
