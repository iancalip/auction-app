class CreateLots < ActiveRecord::Migration[7.0]
  def change
    create_table :lots do |t|
      t.string :code
      t.date :start_date
      t.date :end_date
      t.decimal :minimum_bid
      t.decimal :minimum_bid_difference
      t.integer :status, default: 0
      t.integer :created_by_user_id
      t.integer :approved_by_user_id

      t.timestamps
    end
  end
end
