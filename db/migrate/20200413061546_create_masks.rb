class CreateMasks < ActiveRecord::Migration[5.0]
  def change
    create_table :masks do |t|
      t.string :name
      t.string :image
      t.text :infomation
      t.integer :stock
      t.timestamps
    end
  end
end
