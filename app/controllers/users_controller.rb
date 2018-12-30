class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:message] = "You are registered and logged in"
      session[:user_id] = @user.id
      redirect_to profile_path(@user)
    else
      add_errors_on_flash(@user)
      render :new
    end
  end

  def index
    @users = User.all
    @biggest_orders = Order.biggest_orders
    if admin_user?
      @merchants = User.where(role: "merchant")
    else
      @merchants = User.where(enabled: true, role: "merchant")
    end
    @top_merch_quantity = @merchants.top_merch_quantity
    @top_merch_revenue = @merchants.top_merch_revenue
    @fastest_fulfillment = @merchants.fastest_fulfillment
    @slowest_fulfillment = @merchants.slowest_fulfillment
    @top_states = @users.top_states
    @top_cities = @users.top_cities
  end

  private

  def user_params
    params.require(:user).permit(:name, :address, :city, :state, :email, :password, :zip_code, :password_confirmation)
  end
end
