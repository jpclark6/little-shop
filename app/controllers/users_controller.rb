class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def errors
    {
      email: 'Your email',
      name: 'Your name',
      address: 'Your address',
      city: 'Your city',
      state: 'Your state',
      zip_code: 'Your zip code',
      password: 'Your password',
      password_confirmation: 'Your Password'
    }
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:message] = "You are registered and logged in"
      session[:user_id] = @user.id
      redirect_to profile_path(@user)
    else
      @user.errors.each do |attribute, message|
        flash[attribute] = "#{errors[attribute]} #{message}."  # add which items - stretch goal - show error from active record
      end
      render :new
    end
  end

  def show
    @user = current_user
  end

  def edit
  end

  def index
    if current_user && current_user.admin?
      @merchants = User.where(role: "merchant")
    else
      @merchants = User.where(enabled: true, role: "merchant")
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :address, :city, :state, :email, :password, :zip_code, :password_confirmation)
  end

end
