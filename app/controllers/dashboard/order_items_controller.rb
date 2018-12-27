class Dashboard::OrderItemsController < ApplicationController
  before_action :require_merchant

  def fulfill
    order_item = OrderItem.find(params[:id])
    if order_item.pending?
      order_item.update(fulfilled: true)
      redirect_to dashboard_order_path(order)
    end
  end
end
