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

  def top_5_items
    Item.joins(:order_items).select("items.*, sum(order_items.quantity) as item_count").where("order_items.fulfilled=true").group(:id).order("item_count desc").limit(5)
  end

  def total_items_sold
    OrderItem.joins(:item).select("sum(quantity) as total_quantity").where("items.user_id=#{id}").where("fulfilled=true")[0].total_quantity
  end

  def total_items_in_stock
    Item.select("sum(instock_qty) as total_stock").where("user_id=#{id}")[0].total_stock
  end

  def total_items
    if total_items_sold && total_items_in_stock
      return total_items_sold + total_items_in_stock
    else
      return Float::INFINITY
    end
  end

  def percent_items_sold
    "#{(total_items_sold.to_f / total_items * 100).round}%"
  end

  def top_3_states
    states = OrderItem.joins(order: :user).joins(:item).where("items.user_id=#{id}").where("fulfilled=true").select("users.state, sum(quantity) as total_quantity").group("users.state").order("total_quantity desc").limit(3)
    if states[2]
      [states[0].state, states[1].state, states[2].state]
    elsif states[1]
      [states[0].state, states[1].state]
    elsif states[0]
      [states[0].state]
    else
      ["No shipments"]
    end
  end

  def top_3_city_states
    city_states = OrderItem.joins(order: :user).joins(:item).where("items.user_id=#{id}").where("fulfilled=true").select("users.city, users.state, sum(quantity) as total_quantity").group("users.city, users.state").order("total_quantity desc").limit(3)
    if city_states[2]
      ["#{city_states[0].city}, #{city_states[0].state}",
      "#{city_states[1].city}, #{city_states[1].state}",
      "#{city_states[2].city}, #{city_states[2].state}"]
    elsif city_states[1]
      ["#{city_states[0].city}, #{city_states[0].state}",
      "#{city_states[1].city}, #{city_states[1].state}"]
    elsif city_states[0]
      ["#{city_states[0].city}, #{city_states[0].state}"]
    else
      ["Not enough data"]
    end
  end

  def top_customer_by_orders
    User.joins(orders: {order_items: :item}).where("items.user_id=#{id}").where("order_items.fulfilled=true").select("users.*, count(orders.id) as order_qty").group("users.id").order("order_qty desc").first
  end

  def top_customer_by_qty
    User.joins(orders: {order_items: :item}).where("items.user_id=#{id}").where("order_items.fulfilled=true").select("users.*, count(order_items.id) as total_qty").group("users.id").order("total_qty desc").first
  end

  def top_3_customers_by_total_paid
    User.joins(orders: {order_items: :item}).where("items.user_id=#{id}").where("order_items.fulfilled=true").select("users.*, sum(order_items.price * order_items.quantity) as total_paid").group("users.id").order("total_paid desc").limit(3)
  end
end
