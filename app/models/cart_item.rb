class CartItem < ApplicationRecord
  belongs_to :mask
  belongs_to :cart
  belongs_to :user
end
