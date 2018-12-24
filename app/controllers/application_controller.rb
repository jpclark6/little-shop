class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  before_action :set_cart

  def set_cart
    @cart ||= Cart.new(session[:cart])
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_admin?
    current_user && current_user.admin?
  end

  def merchant_user?
   current_user && current_user.merchant?
  end

  def require_current_user
    unless current_user && current_user.registered?
      render file: "/public/404", status: :not_found
    end
  end

  def require_merchant
    render file: "/public/404", status: :not_found unless merchant_user?
  end

  def no_merchants_allowed
    if merchant_user?
      render file: "/public/404", status: :not_found
    end
  end

  def no_admins_allowed
    if current_admin?
      render file: "/public/404", status: :not_found
    end
  end


end
