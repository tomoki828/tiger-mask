class CartsController < ApplicationController
  protect_from_forgery
  before_action :set_cart_item!,   only: :add_item
  before_action :setup_cart_item!, only: [:update_item, :delete_item]

  def index
    @tiger   = Mask.find_by(id: 1)
    @lion    = Mask.find_by(id: 2)
    @cheetah = Mask.find_by(id: 3)
    @cat     = Mask.find_by(id: 4)

    @products = []
    carts = Cart.all.order("created_at DESC")
      carts.each do |cart|
        mask = cart.masks
          mask.each do |mask|
            product = {}
            product[:name]  = mask[:name]
            product[:image] = mask[:image]
            product[:price] = mask[:price]
            @products << product
          end
      end
  end
  
  def show
    # cart = Cart.find(params[:id])
    # @mask = cart.masks
  end

  # 商品一覧画面から、「商品購入」を押した時のアクション
  def add_item
    if @cart_item.blank?
      @cart_item = current_cart.cart_items.build(mask_id: params[:id])
    end

    @cart_item.quantity += params[:number].to_i
    @cart_item.save
    redirect_to root_path
    # redirect_to cart_path(params[:id])
  end

  # カート詳細画面から、「更新」を押した時のアクション
  def update_item
    @cart_item.update(quantity: params[:number].to_i)
    redirect_to root_path
  end

  # カート詳細画面から、「削除」を押した時のアクション
  def delete_item
    @cart = Cart.find(params[:id])
    @cart_item.destroy
    @cart.destroy
    redirect_to root_path
  end

  private
    # 送られてきたidから現在のカートの中身を@cart_itemと定義
    def set_cart_item!
      @cart_item = current_cart.cart_items.find_by(mask_id: params[:id])
    end

    def setup_cart_item!
      @cart_item = cart_info.cart_items.find_by(cart_id: params[:id])
    end 
end