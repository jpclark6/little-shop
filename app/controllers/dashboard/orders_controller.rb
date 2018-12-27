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

  # def toggle_enabled(object)
  #   if object.enabled?
  #     object.update(enabled: false)
  #     flash[:alert] = "#{object.class} #{object.id} with name '#{object.name}' is now disabled."
  #   else
  #     object.update(enabled: true)
  #     flash[:alert] = "#{object.class} #{object.id} with name '#{object.name}' is now enabled."
  #   end
  # end
  #
  # def toggle
  #   item = Item.find(params[:id])
  #   toggle_enabled(item)
  #   redirect_to admin_merchant_items_path(item.user)
  # end

  def fulfill
    order_item = Order.find(params[:id])
    if order.pending?
      order_item.update(fulfilled: true)
      redirect_to dashboard_order_path(order)
    end
  end
end
