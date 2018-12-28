class OrderItem < ApplicationRecord
  validates_presence_of :price, :quantity
  before_validation :ensure_quantity, :ensure_price

  belongs_to :item
  belongs_to :order

  def subtotal
    quantity * price
  end

  def fulfillable?
    if !fulfilled? && item.instock_qty >= quantity
      true
    else
      false
    end
  end

  # def fulfill_order_item
  #   item.instock_qty - 1
  # end

  private

  def ensure_quantity
    self.quantity ||= 1
  end

  def ensure_price
    self.price ||= item.price
  end

end
