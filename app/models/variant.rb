class Variant < ApplicationRecord
  belongs_to :product
  has_many :variants_orders, dependent: :destroy
  has_many :orders, through: :variants_orders
end
