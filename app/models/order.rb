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

  def read_view
    body = {
      order_id: id,
      customer_id: customer_id,
      total_price: ('%.2f' % total_price),
      status: status,
      created_at: created_at,
      updated_at: updated_at,
      variants: []
    }
    variants_orders.includes(:variant).each do |vo|
      body[:variants] << {
        id: vo.variant.id,
        name: vo.variant.name,
        price: ('%.2f' % vo.variant.cost),
        quantity: vo.quantity
      }
    end
    body
  end
end
