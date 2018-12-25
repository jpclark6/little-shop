class Dashboard::UsersController < ApplicationController
  before_action :require_merchant

  def show
    @user = current_user
    @orders = @user.merchant_pending_orders
    render template: 'dashboard/users/show'
  end

end
