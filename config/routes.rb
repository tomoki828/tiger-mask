Rails.application.routes.draw do
  devise_for :users
  root "masks#index"
  resources :users, only: [:index]
  resources :cards, only: [:new, :create, :show, :destroy]

  resources :masks, only: [:show] do
    collection do
      get 'about_us'
    end
  end
  resources :carts, only: [:index, :show] do
    collection do
      get 'purchase'
      get 'payment'
      get 'donation_logs'
    end
  end

  post '/add_item' => 'carts#add_item'
  post '/update_item' => 'carts#update_item'
  delete '/delete_item' => 'carts#delete_item'
end
