class CartsController < ApplicationController
  protect_from_forgery
  before_action :set_cart_item!,   only: :add_item
  before_action :setup_cart_item!, only: [:update_item, :delete_item]
  before_action :set_user_carts,   only: [:index, :purchase]
  before_action :set_card,         only: [:purchase, :payment]

  def index
    # @user_carts = uniq_merge(@user_carts, [:name, :user_id], [:quantity])
  end

  def add_item
    if @cart_item.blank?
      @cart_item = current_cart.cart_items.build(mask_id: params[:id])
    end
    @cart_item.quantity += params[:number].to_i
    @cart_item.user_id = params[:user_id].to_i
    @cart_item.save
    redirect_to carts_path
  end

  def update_item
    @cart_item.update(quantity: params[:number].to_i)
    redirect_to carts_path
  end

  def delete_item
    @cart = Cart.find(params[:id])
    @cart_item.destroy
    @cart.destroy
    redirect_to carts_path
  end

  def purchase
    if user_signed_in?
      @user = current_user
      if @user.card.present?
        Payjp.api_key = Rails.application.secrets.payjp_access_key
        customer = Payjp::Customer.retrieve(@card.customer_id)
        @customer_card = customer.cards.retrieve(@card.card_id)
        @card_brand = @customer_card.brand
        case @card_brand
        when "Visa"
          @card_src = "/visa-logo.png"
        when "JCB"
          @card_src = "/JCB.png"
        when "MasterCard"
          @card_src = "/mastercard.jpg"
        when "American Express"
          @card_src = "/Amex.jpg"
        when "Diners Club"
          @card_src = "/dinners.png"
        when "Discover"
          @card_src = "/discovercard.jpg"
        end
        @exp_month = @customer_card.exp_month.to_s
        @exp_year = @customer_card.exp_year.to_s.slice(2,3)
      end
    else
      redirect_to users_path
    end
  end

  def payment
    # unless @cart.situation == 0
    #   @cart.situation = 0
    #   @cart.save!
    #   Payjp.api_key = Rails.application.secrets.payjp_access_key
    #   charge = Payjp::Charge.create(
    #   amount: @cart.price,
    #   customer: Payjp::Customer.retrieve(@card.customer_id),
    #   currency: 'jpy'
    #   )
    # else
    #   redirect_to carts_path
    # end
  end

  private
    # 送られてきたidから現在のカートの中身を@cart_itemと定義するメソッド
    def set_cart_item!
      @cart_item = current_cart.cart_items.find_by(mask_id: params[:id])
    end

    def setup_cart_item!
      @cart_item = cart_info.cart_items.find_by(cart_id: params[:id])
    end 

    def set_user_carts
      @user_carts  = []
      @total_price = 0
      carts = Cart.all.order("created_at DESC")
      carts.each do |cart|
        cart.masks.zip(cart.cart_items).each do |m, c|
          if current_user.id == c.user_id
            user_cart = {}
            user_cart[:name]  = m[:name]
            user_cart[:image] = m[:image]
            user_cart[:price] = m[:price]
            user_cart[:quantity] = c.quantity
            user_cart[:cart_id] = c.cart_id
            user_cart[:user_id] = c.user_id
            user_cart[:total_price] = user_cart[:price] * user_cart[:quantity]
            @user_carts << user_cart
          end
        end
      end
      @user_carts.each do |user_cart|
        @total_price += user_cart[:total_price]
      end
    end

    def set_card
      @card = Card.find_by(user_id: current_user.id)
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