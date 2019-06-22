class Variant < ApplicationRecord
  belongs_to :product
  has_many :variants_orders, dependent: :destroy
  has_many :orders, through: :variants_orders

  validates_presence_of :name
  validates_presence_of :cost
  validates_presence_of :stock_amount
  validates_presence_of :weight
  validates_presence_of :product_id

  def update_stock_amount(quantity)
    self.stock_amount = stock_amount - quantity
    self.save
  end
end
