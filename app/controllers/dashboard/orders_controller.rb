class Dashboard::OrdersController < ApplicationController
  def index
    @orders = Order.where(user: current_user).where(status: 'pending')
  end
end
