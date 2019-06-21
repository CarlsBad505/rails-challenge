class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :customer_id
      t.decimal :total_price, precision: 10, scale: 2
      t.string :status, default: "pending"
      t.timestamps
    end
    add_index :orders, :customer_id
  end
end
