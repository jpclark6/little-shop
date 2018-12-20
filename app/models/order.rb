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

  def total_amount
    order_items.sum { |oi| oi.price * oi.quantity }
  end

  def total_item_count
    order_items.sum { |oi| oi.quantity }
  end
end
