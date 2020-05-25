class CartsController < ApplicationController
  protect_from_forgery
  before_action :set_cart_item!,   only: :add_item
  before_action :setup_cart_item!, only: [:update_item, :delete_item]

  def index
    @user_carts  = []
    @total_price = 0
    carts = Cart.all.order("created_at DESC")
    carts.each do |cart|
      cart.masks.zip(cart.cart_items).each do |m, c|
        user_cart = {}
        user_cart[:name]  = m[:name]
        user_cart[:image] = m[:image]
        user_cart[:price] = m[:price]
        user_cart[:quantity] = c.quantity
        user_cart[:cart_id] = c.cart_id
        user_cart[:user_id] = c.user_id
        user_cart[:total_price] = user_cart[:price] * user_cart[:quantity]
        @user_carts << user_cart
        @total_price += user_cart[:total_price]
      end
    end
    # @user_carts = uniq_merge(@user_carts, [:name, :user_id], [:quantity])
  end

  # 商品一覧画面から「カートへ入れる」を押した時のアクション
  def add_item
    if @cart_item.blank?
      @cart_item = current_cart.cart_items.build(mask_id: params[:id])
    end
    @cart_item.quantity += params[:number].to_i
    @cart_item.user_id = params[:user_id].to_i
    @cart_item.save
    redirect_to carts_path
  end

  # カート詳細画面から「変更」を押した時のアクション
  def update_item
    @cart_item.update(quantity: params[:number].to_i)
    redirect_to carts_path
  end

  # カート詳細画面から「削除」を押した時のアクション
  def delete_item
    @cart = Cart.find(params[:id])
    @cart_item.destroy
    @cart.destroy
    redirect_to carts_path
  end

  private
    # 送られてきたidから現在のカートの中身を@cart_itemと定義するメソッド
    def set_cart_item!
      @cart_item = current_cart.cart_items.find_by(mask_id: params[:id])
    end

    def setup_cart_item!
      @cart_item = cart_info.cart_items.find_by(cart_id: params[:id])
    end 

    # 重複データを処理するメソッド
    # def uniq_merge(ary, keys = [], values = [])
    #   ary.group_by { |i| keys.map { |key| i[key] } }
    #      .map { |k, v|
    #        v[1..-1].each { |x| values.each { |y| v[0][y] += x[y] } }
    #        v[0]
    #      }
    # end
end