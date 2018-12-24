class Profile::OrdersController < ApplicationController
  before_action :require_current_user
  
  def show
    @order = Order.find(params[:id])
    @user = current_user
    @order_items = @order.order_items
  end

  def index
    @user = current_user
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
