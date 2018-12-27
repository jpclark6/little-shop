class Dashboard::OrdersController < ApplicationController
  before_action :require_merchant

  def index
    @orders = current_user.orders
  end

  def show
    @order = Order.find(params[:id])
    @user = @order.user #customer

    @order_items = current_user.my_order_items(@order)
  end

  def fulfill
  end
end
