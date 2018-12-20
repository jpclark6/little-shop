class Dashboard::OrdersController < ApplicationController
  def index
    @orders = current_user.merchant_pending_orders
  end

  def show
  end
end
