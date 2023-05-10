class AddLotIdToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :lot_id, :integer
  end
end
