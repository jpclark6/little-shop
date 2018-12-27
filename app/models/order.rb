class Order < ApplicationRecord
  validates_presence_of :status

  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items
  enum status: ["pending", "fulfilled", "cancelled"]

  def add_cart(cart)
    cart.contents.each do |item_id, qty|
      item = Item.find(item_id)
      order_items.create(item: item, price: item.price, quantity: qty)
    end
  end

  def total_quantity
    order_items.sum(:quantity)
  end

  def total_price
    order_items. sum("order_items.price * order_items.quantity")
  end

  def pending?
    status == 'pending'
  end

  def cancel_order
    order_items.each do |oi|
      if oi.fulfilled == true
        oi.item.update(instock_qty: (oi.quantity + oi.item.instock_qty))
        oi.update(fulfilled: false)
      end
    end
    update(status: 'cancelled')
  end

  def self.biggest_orders
    Order.joins(:order_items)
         .select("orders.*, sum(order_items.quantity) as order_total")
         .group(:id)
         .order("sum(order_items.quantity) desc")
         .limit(3)
  end
end
