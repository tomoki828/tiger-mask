class CreateCartItems < ActiveRecord::Migration[5.0]
  def change
    create_table :cart_items do |t|
      t.integer :quantity, default: 0
      t.references :mask, foreign_key: true
      t.references :cart, foreign_key: true
      t.integer  :user_id
      t.timestamps
    end
  end
end
