class OrderItem < ApplicationRecord
  validates_presence_of :price, :quantity
  before_validation :ensure_quantity, :ensure_price

  belongs_to :item
  belongs_to :order

  def subtotal
    quantity * price
  end

  def not_fulfilled
    if fulfilled? == false
      return true
    else
      return false
    end
  end

  def fulfillable?
    if not_fulfilled && order.order_items.each do |order_item|
                          order_item.item.instock_qty >= order_item.quantity
                          return true
                        end
      return true
    else
      return false
    end
  end

  private

  def ensure_quantity
    self.quantity ||= 1
  end

  def ensure_price
    self.price ||= item.price
  end
end
