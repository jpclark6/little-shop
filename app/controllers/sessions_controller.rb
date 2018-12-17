class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}"
      if user.registered?
        redirect_to profile_path(user)
      elsif user.merchant?
        redirect_to "/dashboard/#{user.id}"
      elsif user.admin?
        redirect_to root_path
      end
    else
      flash[:failure] = "Invalid credentials."
      render :new
    end
  end
end
