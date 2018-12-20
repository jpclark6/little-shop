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

  def create
    order = Order.new(user: current_user, status: 'pending')
    if order.save
      order.add_cart(@cart)
      flash[:notice] = "Order created successfully"
      redirect_to profile_path
    else
      flash[:error] = "Order not processed"
      redirect_to profile_path
    end
  end
end
