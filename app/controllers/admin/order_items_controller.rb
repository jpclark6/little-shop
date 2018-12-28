class Admin::OrderItemsController < ApplicationController
  before_action :require_admin

  def fulfill
    order_item = OrderItem.find(params[:id])
    order_item.fulfill

    flash[:message] = "Item Fulfilled"
    redirect_to admin_order_path(order_item.order)
  end

end
