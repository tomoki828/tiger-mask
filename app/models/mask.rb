class Mask < ApplicationRecord
  has_many :line_items
  has_many :carts, through: :cart_items
end
