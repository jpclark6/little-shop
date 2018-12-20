class OrdersController < ApplicationController
  def create
    order = Order.create(user: current_user, status: 'pending')
    if order.save
      order.add_cart(@cart)
      flash[:notice] = "Order created successfully"
      session[:cart] = Hash.new(0)
    else
      flash[:error] = "Order not processed"
    end
    redirect_to profile_path
  end
end
