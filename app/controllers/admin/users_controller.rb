class Admin::UsersController < ApplicationController
  before_action :require_admin

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.where(role: ["registered"])
  end

  def update
    user = User.find(params[:id])
    user.enabled = false
    user.save

    flash[:notice] = "#{user.name} (id:#{user.id}) is now disabled."
    redirect_to admin_users_path
  end

  private

  def require_admin
    render file: "/public/404" unless current_admin?
  end
end
