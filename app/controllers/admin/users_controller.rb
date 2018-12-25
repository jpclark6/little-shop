class Admin::UsersController < ApplicationController
  before_action :require_admin

  def show
    @user = User.find(params[:id])
    redirect_to admin_merchant_path(@user) if @user.role == "merchant"
  end

  def merchant_show
    @user = User.find(params[:id])
    if @user.role == "registered"
      redirect_to admin_user_path(@user)
    else
      @orders = @user.merchant_pending_orders
      render template: 'dashboard/users/show'
    end
  end

  def index
    @users = User.where(role: ["registered"])
  end

  def toggle
    user = User.find(params[:id])
    toggle_enabled(user)
    if user.merchant?
      redirect_to merchants_path
    else
      redirect_to admin_users_path
    end
  end

  private

  def require_admin
<<<<<<< HEAD
    render file: "/public/404" unless admin_user?
=======
    render file: "/public/404", status: :not_found unless current_admin?
>>>>>>> 39d518ef00025321d2ae1e885e24e383373bca87
  end

end
