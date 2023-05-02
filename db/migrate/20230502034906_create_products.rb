class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :image
      t.float :weight
      t.float :width
      t.float :height
      t.float :depth
      t.string :category
      t.string :identifier

      t.timestamps
    end
  end
end
