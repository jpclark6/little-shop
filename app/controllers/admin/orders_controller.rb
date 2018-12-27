class Admin::OrdersController < ApplicationController
  before_action :require_admin
  def show
    @order = Order.find(params[:id])
    @order_items = @order.order_items
    @user = @order.user
    @cancel_order_path = :admin_order_path
    render template: "profile/orders/show"
  end
  def destroy
    order = Order.find(params[:id])
    @user = order.user
    order.cancel_order
    flash[:message] = "Order cancelled"
    redirect_to admin_user_path(@user)
  end
end
