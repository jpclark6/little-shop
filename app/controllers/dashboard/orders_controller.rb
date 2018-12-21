class Dashboard::OrdersController < ApplicationController


  def show
    @order = Order.find(params[:id])
    @user = @order.user #customer
  end


end
