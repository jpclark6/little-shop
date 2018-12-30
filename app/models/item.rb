class Item < ApplicationRecord
  validates :price, numericality: {greater_than: 0}
  validates :instock_qty, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  # NOTE: These need to be above the presence validations or will return wrong error message.

  validates_presence_of :name, :instock_qty, :price, :description
  validates_presence_of :image, if: :image
  belongs_to :user
  has_many :order_items
  has_many :orders, through: :order_items

  def self.top_5
    select("items.name, items.id, sum(order_items.quantity) as units_sold")
        .joins(:order_items)
        .where(order_items: {fulfilled: true})
        .group(:id)
        .order("units_sold desc")
        .limit(5)
  end

  def self.bottom_5
    select("items.name, items.id, coalesce(sum(order_items.quantity), 0) as units_sold")
        .left_outer_joins(:order_items)
        .group(:id)
        .order("coalesce(sum(order_items.quantity), 0)")
        .limit(5)
  end

  def never_ordered?
    order_items.empty?
  end

  def avg_fulfillment_time
    results = OrderItem.select("avg(updated_at - created_at) as avg_f_time")
                       .where(item: self, fulfilled: true)
    if results.present?
      return results.first['avg_f_time']
    else
      return nil
    end
  end
end
