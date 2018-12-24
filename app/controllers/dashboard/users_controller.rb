class Dashboard::UsersController < ApplicationController
  before_action :require_current_user

  def show
    @user = current_user
    @orders = current_user.merchant_pending_orders
  end

end
