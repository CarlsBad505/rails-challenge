class Order < ApplicationRecord
  belongs_to :customer
  has_many :variants_orders, dependent: :destroy
  has_many :variants, through: :variants_orders

  validates_presence_of :customer_id
  validates_presence_of :total_price

  def build_order(params)
    total_price = 0
    params[:variants].each do |variant|
      v = Variant.find_by_id(variant[:id])
      total_price += (v.cost * variant[:quantity])
      self.variants_orders.build(
        variant_id: variant[:id],
        quantity: variant[:quantity]
      )
    end
    self.customer_id = params[:customer_id]
    self.total_price = total_price
  end
end
