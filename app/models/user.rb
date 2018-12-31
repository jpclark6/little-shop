class User < ApplicationRecord
  validates_presence_of :email, :name, :role, :address, :city, :state, :zip_code
  validates_presence_of :password, if: :password
  validates_uniqueness_of :email
  validates_confirmation_of :password

  has_many :orders
  has_many :items
  enum role: ["registered", "merchant", "admin"]

  has_secure_password

  def self.top_merch_quantity
    where(role: "merchant")
        .joins(:items)
        .joins("inner join order_items on items.id = order_items.item_id")
        .where(order_items:{fulfilled: true})
        .group(:id)
        .order(" sum_order_items_quantity desc")
        .select("users.*, sum(order_items.quantity) as sum_order_items_quantity")
        .limit(3)
  end

  def self.top_merch_revenue
    where(role: "merchant")
        .joins(:items)
        .joins("inner join order_items on items.id = order_items.item_id")
        .where(order_items:{fulfilled: true})
        .group(:id)
        .order(" sum_order_items_revenue desc")
        .select("users.*, sum(order_items.quantity * order_items.price) as sum_order_items_revenue")
        .limit(3)
  end

  def self.fastest_fulfillment
    select('users.*, avg(order_items.updated_at-order_items.created_at) as fulfillment_time')
        .joins(items: :order_items)
        .where('order_items.fulfilled = true')
        .group('users.id')
        .order('fulfillment_time')
        .limit(3)
  end

  def self.slowest_fulfillment
    select('users.*, avg(order_items.updated_at-order_items.created_at) as fulfillment_time')
        .joins(items: :order_items)
        .where('order_items.fulfilled = true')
        .group('users.id')
        .order('fulfillment_time desc')
        .limit(3)
  end

  def self.top_states
    select("users.state, count(orders.id) as order_count")
        .joins(:orders)
        .group("users.state")
        .where("orders.status=?", 1)
        .order("count(orders.id) desc")
        .limit(3)
  end

  def self.top_cities
    select("users.city, count(orders.id) as order_count")
        .joins(:orders)
        .group("users.city, users.state")
        .where("orders.status=?", 1)
        .order("count(orders.id) desc")
        .limit(3)
  end

  def status
    enabled? ? "Enabled" : "Disabled"
  end

  def my_order_items(order)
    OrderItem.joins(:item)
        .where(order: order, items: {user_id: id})
  end

  def merchant_pending_orders
    Order.select("orders.*")
        .joins(:items)
        .where("items.user_id=#{id}")
        .where(orders: {status: :pending})
        .group(:id)
  end

  def top_5_items
    Item.select("items.*, sum(order_items.quantity) as item_count")
        .joins(:order_items)
        .where("order_items.fulfilled=true")
        .where("user_id=#{id}")
        .group(:id)
        .order("item_count desc")
        .limit(5)
  end

  def total_items_sold
    OrderItem.select("sum(quantity) as total_quantity")
        .joins(:item)
        .where("fulfilled=true")
        .find_by("items.user_id=#{id}")
        .total_quantity
  end

  def total_items_in_stock
    Item.select("sum(instock_qty) as total_stock")
        .find_by("user_id=#{id}")
        .total_stock
  end

  def total_items
    (total_items_sold || 0) + (total_items_in_stock || 0)
  end

  def percent_items_sold
    (total_items_sold.to_f / (total_items.nonzero? || 1) * 100).round
  end

  def top_3_states
    OrderItem.select("users.state, sum(quantity) as total_quantity")
        .joins(order: :user)
        .joins(:item)
        .where("items.user_id=#{id}")
        .where("fulfilled=true")
        .group("users.state")
        .order("total_quantity desc")
        .limit(3)
  end

  def top_3_city_states
    OrderItem.select("users.city, users.state, sum(quantity) as total_quantity")
        .joins(order: :user)
        .joins(:item)
        .where("items.user_id=#{id}")
        .where("fulfilled=true")
        .group("users.city, users.state")
        .order("total_quantity desc")
        .limit(3)
  end

  def top_customer_by_orders
    User.select("users.*, count(orders.id) as order_qty")
        .joins(orders: {order_items: :item})
        .where("items.user_id=#{id}")
        .where("order_items.fulfilled=true")
        .group("users.id")
        .order("order_qty desc")
        .first
  end

  def top_customer_by_qty
    User.select("users.*, count(order_items.id) as total_qty")
        .joins(orders: {order_items: :item})
        .where("items.user_id=#{id}")
        .where("order_items.fulfilled=true")
        .group("users.id")
        .order("total_qty desc")
        .first
  end

  def top_3_customers_by_total_paid
    User.select("users.*, sum(order_items.price * order_items.quantity) as total_paid")
        .joins(orders: {order_items: :item})
        .where("items.user_id=#{id}")
        .where("order_items.fulfilled=true")
        .group("users.id").order("total_paid desc")
        .limit(3)
  end
end
