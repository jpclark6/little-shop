class Dashboard::UsersController < ApplicationController
  def show
    @user = current_user
    @orders = current_user.merchant_pending_orders
  end
end
