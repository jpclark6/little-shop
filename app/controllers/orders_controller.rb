class OrdersController < ApplicationController
  def create
    order = Order.create(user: current_user, status: 'pending')
    order.add_cart(@cart)
    redirect_to profile_path
  end
end
