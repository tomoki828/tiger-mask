class AddDetailToMasks < ActiveRecord::Migration[5.0]
  def change
    add_column :masks, :detail, :text
  end
end
