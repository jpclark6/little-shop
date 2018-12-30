class Order < ApplicationRecord
  validates_presence_of :status

  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items
  enum status: ["pending", "fulfilled", "cancelled"]

  def add_cart(cart)
    cart.contents.each do |item_id, quantity|
      item = Item.find(item_id)
      order_items.create(item: item, price: item.price, quantity: quantity)
    end
  end

  def total_quantity
    order_items.sum(:quantity)
  end

  def total_price
    order_items.sum("order_items.price * order_items.quantity")
  end

  def cancel_order
    order_items.each do |order_item|
      if order_item.fulfilled?
        order_item.item.update(instock_qty: (order_item.quantity + order_item.item.instock_qty))
        order_item.update(fulfilled: false)
      end
    end
    update(status: 'cancelled')
  end

  def self.biggest_orders
    select("orders.*, sum(order_items.quantity) as order_total")
        .joins(:order_items)
        .group(:id)
        .order("sum(order_items.quantity) desc")
        .limit(3)
  end

  def fulfill_if_complete
    update(status: "fulfilled") if order_items.all?(&:fulfilled)
  end
end
