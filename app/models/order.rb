class Order < ApplicationRecord
  belongs_to :customer
  has_many :variants_orders, dependent: :destroy
  has_many :variants, through: :variants_orders
end
