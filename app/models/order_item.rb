class OrderItem < ApplicationRecord
  belongs_to :item
  belongs_to :order

  def subtotal
    quantity * price
  end
end
