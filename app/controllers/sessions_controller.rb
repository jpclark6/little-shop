class SessionsController < ApplicationController
  def new
    if current_user
      flash[:logged_in] = "You are already logged in."
      case current_user.role
      when 'registered'
        redirect_to profile_path
      when 'merchant'
        redirect_to "/dashboard"
      when 'admin'
        redirect_to root_path
      end
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password]) && user.enabled?
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}"
      if user.registered?
        redirect_to profile_path
      elsif user.merchant?
        redirect_to "/dashboard"
      elsif user.admin?
        redirect_to root_path
      end
    else
      flash[:failure] = "Invalid credentials."
      flash[:failure] = "Account Disabled." unless current_user && current_user.enabled?
      render :new
    end
  end

  def destroy
    session.clear
    flash[:logged_out] = "You are logged out."
    redirect_to root_path
  end
end
