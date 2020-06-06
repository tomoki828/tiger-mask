class UsersController < ApplicationController

  before_action :set_card, only:[:index]

  def index
  end

  def set_card
    card = Card.where(user_id: current_user.id)
    if card.exists?
      @card =card[0]
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
  end

end
