class Profile::UsersController < ApplicationController
  before_action :require_current_user

  def show
    @user = current_user
    @order_path = :profile_order_path
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:success] = "Your data is updated"
      redirect_to profile_path
    else
      flash[:error] = "the email you entered is already taken"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :address, :city, :state, :email, :password, :zip_code, :password_confirmation)
  end
end
