class VariantsOrder < ApplicationRecord
  belongs_to :order
  belongs_to :variant
end
