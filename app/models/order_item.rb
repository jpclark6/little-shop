class OrderItem < ApplicationRecord
  validates_presence_of :price, :quantity
  before_validation :ensure_quantity, :ensure_price

  belongs_to :item
  belongs_to :order

  def subtotal
    quantity * price
  end

  def fulfillable?
    !fulfilled? && item.instock_qty >= quantity ? true : false
  end

  def fulfill
    new_instock_qty = item.instock_qty - quantity
    item.update(instock_qty: new_instock_qty)
    update(fulfilled: true)
    order.fulfill_if_complete
  end

  private

  def ensure_quantity
    self.quantity ||= 1
  end

  def ensure_price
    self.price ||= item.price
  end

end
