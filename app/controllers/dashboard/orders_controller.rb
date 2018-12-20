class Dashboard::OrdersController < ApplicationController
  def index
    @orders = Order.joins(:items).select("orders.*").where("items.user_id=#{current_user.id}").where(orders: {status: :pending})
  end
end
