class OrdersController < ApplicationController
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
