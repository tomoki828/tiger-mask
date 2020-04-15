class Cart < ApplicationRecord
  has_many :cart_items
  has_many :masks, through: :cart_items
end
