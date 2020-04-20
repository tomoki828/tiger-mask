class CartsController < ApplicationController
  protect_from_forgery
  before_action :set_cart_item!,   only: :add_item
  before_action :setup_cart_item!, only: [:update_item, :delete_item]

  def index
    # ヘッダーに表示に必要なインスタンス変数を定義
    @tiger   = Mask.find_by(id: 1)
    @lion    = Mask.find_by(id: 2)
    @cheetah = Mask.find_by(id: 3)
    @cat     = Mask.find_by(id: 4)

    @products   = []
    @products_carts  = []

    carts = Cart.all.order("created_at DESC")

      carts.each do |cart|
        # 中間テーブルからquantityの値を取り出し、配列(@quantitys)に代入
        cart.cart_items.each do |c|
          products_cart = {}
          products_cart[:quantity] = c.quantity
          products_cart[:cart_id] = c.cart_id
          @products_carts << products_cart
        end

        # カート情報に合うmasksテーブルのデータを配列(@products)に代入
        mask = cart.masks
        mask.each do |m|
          product = {}
          product[:name]  = m[:name]
          product[:image] = m[:image]
          product[:price] = m[:price]
          @products << product
        end
                
      end
  end
  
  # 商品一覧画面から、「商品購入」を押した時のアクション
  def add_item
    if @cart_item.blank?
      @cart_item = current_cart.cart_items.build(mask_id: params[:id])
    end

    @cart_item.quantity += params[:number].to_i
    @cart_item.save
    redirect_to carts_path
  end

  # カート詳細画面から、「更新」を押した時のアクション
  def update_item
    @cart_item.update(quantity: params[:number].to_i)
    redirect_to carts_path
  end

  # カート詳細画面から、「削除」を押した時のアクション
  def delete_item
    @cart = Cart.find(params[:id])
    @cart_item.destroy
    @cart.destroy
    redirect_to carts_path
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