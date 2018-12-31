class Dashboard::OrdersController < ApplicationController
  before_action :require_merchant

  def show
    @order = Order.find(params[:id])
    @user = @order.user
    @order_items = current_user.my_order_items(@order)
    @order_item_fulfill_path = :dashboard_order_item_fulfill_path
    
  end
end
