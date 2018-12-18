class Admin::UsersController < ApplicationController
  before_action :require_admin

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.where.not(role: ["admin", "merchant"])
  end

  private

  def require_admin
    render file: "/public/404" unless current_admin?
  end
end
