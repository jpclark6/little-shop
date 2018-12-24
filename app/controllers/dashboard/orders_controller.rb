class Dashboard::OrdersController < ApplicationController
  before_action :require_current_user
  
  def index
    @orders = current_user.orders
  end

  def show
  end
end
