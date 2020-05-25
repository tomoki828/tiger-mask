class CartItem < ApplicationRecord
  belongs_to :mask
  belongs_to :cart, dependent: :destroy
  belongs_to :user
end
