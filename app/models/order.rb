class Order < ApplicationRecord
  validates_presence_of :status

  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items
  enum status: ["pending", "fulfilled", "cancelled"]

  def total_quantity
    order_items.sum(:quantity)
  end

  def total_price
    order_items.sum(:price)
  end
end
