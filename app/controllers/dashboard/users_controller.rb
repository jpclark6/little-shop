class Dashboard::UsersController < ApplicationController
  before_action :require_merchant

  def show
    @user = current_user
    @orders = current_user.merchant_pending_orders
  end

end
