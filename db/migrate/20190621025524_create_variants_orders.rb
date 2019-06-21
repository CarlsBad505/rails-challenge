class CreateVariantsOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :variants_orders do |t|
      t.integer :order_id
      t.integer :variant_id
      t.integer :quantity
    end
    add_index :variants_orders, :order_id
    add_index :variants_orders, :variant_id
  end
end
