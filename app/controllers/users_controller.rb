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
      flash[:message] = "Missing content"
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def index
    @merchants = User.where(enabled: true, role: "merchant")
  end

  private

  def user_params
    params.require(:user).permit(:name, :address, :city, :state, :email, :password, :zip_code, :password_confirmation)
  end

end
