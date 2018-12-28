class Admin::UsersController < ApplicationController
  before_action :require_admin

  def show
    @user = User.find(params[:id])
    @order_path = :admin_order_path
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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Your data is updated"
      redirect_to admin_user_path(@user)
    else
      flash[:error] = "the email you entered is already taken"
      render :edit
    end
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
    render file: "/public/404", status: :not_found unless admin_user?
  end

  def user_params
    params.require(:user).permit(:name, :address, :city, :state, :email, :password, :zip_code, :password_confirmation)
  end

end
