class CartsController < ApplicationController
  protect_from_forgery
  before_action :set_cart_item!,   only: :add_item
  before_action :setup_cart_item!, only: [:update_item, :delete_item]
  before_action :set_carts,        only: [:index, :purchase, :payment, :donation_logs]
  before_action :set_card,         only: [:purchase, :payment]
  before_action :set_header,       only: [:donation_logs]


  def index
  end

  def add_item
    @cart_item.quantity += params[:number].to_i
    @cart_item.user_id = params[:user_id].to_i
    @cart_item.status = params[:status]
    @cart_item.save
    duplication_processing
    redirect_to carts_path
  end

  def update_item
    @cart_item.update(quantity: params[:number].to_i)
    redirect_to carts_path
  end

  def delete_item
    @cart = Cart.find(params[:id])
    @cart_item.destroy
    redirect_to carts_path
  end

  def duplication_processing
    carts = Cart.all
    carts_number = Cart.count
    carts.first(carts_number - 1).each do |cart|
      duplication_cart_item = cart.cart_items[0]
      if duplication_cart_item[:status] == "cart" && duplication_cart_item[:mask_id] == params[:id].to_i && duplication_cart_item[:user_id] == params[:user_id].to_i
          @cart_item.destroy
          duplication_cart_item.quantity += params[:number].to_i
          duplication_cart_item.save
          break
      end
    end
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
    carts = Cart.all
    carts.each do |cart|
      cart_item = cart.cart_items[0]
      if cart_item[:user_id] == current_user.id && cart_item[:status] == "cart"
        cart_item[:status] = "sold"
        cart_item.save!
      end
    end
    Payjp.api_key = Rails.application.secrets.payjp_access_key
    charge = Payjp::Charge.create(
    amount: @total_price,
    customer: Payjp::Customer.retrieve(@card.customer_id),
    currency: 'jpy'
    )
  end

  def donation_logs
  end

  private
    # 送られてきたidから現在のカートの中身を@cart_itemと定義するメソッド
    def set_cart_item!
      if @cart_item.blank?
        @cart_item = current_cart.cart_items.build(mask_id: params[:id])
      else
        @cart_item = current_cart.cart_items.find_by(mask_id: params[:id])
      end
    end

    def setup_cart_item!
      @cart_item = cart_info.cart_items.find_by(cart_id: params[:id])
    end 

    def set_carts
      @user_carts  = []
      @total_price = 0
      @total_donation = 0
      carts = Cart.all.order("created_at DESC")
        carts.each do |cart|
          cart.masks.zip(cart.cart_items).each do |m, c|
            if c.user_id == current_user.id && c.status == "cart"
              user_cart = {}
              user_cart[:name]  = m[:name]
              user_cart[:image] = m[:image]
              user_cart[:price] = m[:price]
              user_cart[:quantity] = c.quantity
              user_cart[:cart_id] = c.cart_id
              user_cart[:user_id] = c.user_id
              user_cart[:status] = c.status
              user_cart[:total_price] = user_cart[:price] * user_cart[:quantity]
              @user_carts << user_cart
            end
            if c.status == "sold"
              @total_donation += m[:price] * c.quantity / 10
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

    def set_header
      @tiger   = Mask.find_by(id: 1)
      @lion    = Mask.find_by(id: 2)
      @cheetah = Mask.find_by(id: 3)
      @cat     = Mask.find_by(id: 4)
    end
end