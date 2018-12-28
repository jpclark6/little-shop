class User < ApplicationRecord
  validates_presence_of :email, :name, :role, :address, :city, :state, :zip_code
  validates_presence_of :password, if: :password
  validates_uniqueness_of :email
  validates_confirmation_of :password

  has_many :orders
  has_many :items
  enum role: ["registered", "merchant", "admin"]

  has_secure_password


  def self.fastest_fulfillment
   User.select('users.*, avg(order_items.updated_at-order_items.created_at) as fulfillment_time')
       .joins(items: :order_items)
       .where('order_items.fulfilled = true')
       .group('users.id')
       .order('fulfillment_time asc')
       .limit(3)
  end

  def self.top_merch_quantity
    User.where(role: "merchant")
        .joins(:items)
        .joins("inner join order_items on items.id = order_items.item_id")
        .where(order_items:{fulfilled: true})
        .group(:id)
        .order(" sum_order_items_quantity desc")
        .select("users.*, sum(order_items.quantity) as sum_order_items_quantity")
        .limit(3)
  end

  def self.fastest_fulfillment
    User.select('users.*, avg(order_items.updated_at-order_items.created_at) as fulfillment_time')
        .joins(items: :order_items)
        .where('order_items.fulfilled = true')
        .group('users.id')
        .order('fulfillment_time')
        .limit(3)
  end

  def self.slowest_fulfillment
    User.select('users.*, avg(order_items.updated_at-order_items.created_at) as fulfillment_time')
        .joins(items: :order_items)
        .where('order_items.fulfilled = true')
        .group('users.id')
        .order('fulfillment_time desc')
        .limit(3)
  end

  def self.top_merch_price
        where(role: "merchant")
        .joins(:items)
        .joins("inner join order_items on items.id = order_items.item_id")
        .where(order_items:{fulfilled: true})
        .group(:id)
        .order(" sum_order_items_price desc")
        .select("users.*, sum(order_items.price) as sum_order_items_price")
        .limit(3)
  end

  def self.top_states
        select("users.state, count(orders.id) as order_count")
        .joins(:orders)
        .group("users.state")
        .where("orders.status=?", 1)
        .order("count(orders.id) desc")
        .limit(3)
        .pluck(:state)
  end

  def self.top_cities
        select("users.city, count(orders.id) as order_count")
        .joins(:orders)
        .group("users.city, users.state")
        .where("orders.status=?", 1)
        .order("count(orders.id) desc")
        .limit(3)
        .pluck(:city)
  end

  def status
   enabled? ? "Enabled" : "Disabled"
  end

  def my_order_items(order)
    OrderItem.joins(:item).where(order: order, items: {user_id: self.id})
  end

  def merchant_pending_orders
    Order.joins(:items).select("orders.*").where("items.user_id=#{self.id}").where(orders: {status: :pending}).group(:id)
  end
end
