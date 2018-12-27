class Dashboard::OrderItemsController < ApplicationController
  before_action :require_merchant

  def fulfill
    order_item = OrderItem.find(params[:id])
    if order_item.fulfilled?
      order_item.update(fulfilled: true)
      binding.pry
      redirect_to dashboard_order_path(order)
    end
  end
end
