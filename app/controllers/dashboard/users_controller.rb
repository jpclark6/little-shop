class Dashboard::UsersController < ApplicationController
  before_action :require_merchant

  def show
    if current_user.merchant?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    @orders = @user.merchant_pending_orders
    render template: 'dashboard/users/show'
  end
end
