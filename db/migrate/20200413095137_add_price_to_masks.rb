class AddPriceToMasks < ActiveRecord::Migration[5.0]
  def change
    add_column :masks, :price, :integer
  end
end
