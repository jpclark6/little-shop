class Item < ApplicationRecord
  validates_presence_of :name, :instock_qty, :price, :description
  validates_presence_of :image, if: :image
  # validates :instock_qty
  # validates :price
  belongs_to :user
  has_many :order_items
  has_many :orders, through: :order_items


  def never_ordered?
    order_items.empty?
  end
end
