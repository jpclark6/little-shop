class OrdersController < ApplicationController

  def show
    @order = Order.find(params[:id])
    if merchant_user?
      @user = User.find(@order.user_id)
      @items = @order.items_for_merchant(current_user.id)
    else
      @user = current_user
      @items = @order.items.all
    end
  end
end
