class Dashboard::OrdersController < ApplicationController
  before_action :require_merchant

  def show
    @order = Order.find(params[:id])
    @user = @order.user
    @order_items = current_user.my_order_items(@order)
  end
end
