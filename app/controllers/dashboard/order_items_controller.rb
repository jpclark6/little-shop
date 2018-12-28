class Dashboard::OrderItemsController < ApplicationController
  before_action :require_merchant

  def fulfill
    order_item = OrderItem.find(params[:id])
    # order_item.fulfill_order_item

    new_amount = order_item.item.instock_qty - 1
    order_item.update(instock_qty: new_amount)
    order_item.update(fulfilled: true)
    flash[:message] = "Item Fulfilled"
    redirect_to dashboard_order_path(order_item.order)
  end
end
