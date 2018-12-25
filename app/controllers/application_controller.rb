class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :merchant_user?, :admin_user?
  before_action :set_cart

  def set_cart
    @cart ||= Cart.new(session[:cart])
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def admin_user?
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

  def add_errors_on_flash(object_with_errors)
    object_with_errors.errors.each do |attribute, message|
      flash[attribute] = "#{error_prefix[object_with_errors.class.to_s]} #{attribute} #{message}."
    end
  end

  private

  def error_prefix
    {
      "User" => "Your",
      "Item" => "Item"
    }
  end

  def toggle_enabled(object)
    if object.enabled?
      object.update(enabled: false)
      flash[:alert] = "#{object.class} #{object.id} with name '#{object.name}' is now disabled."
    else
      object.update(enabled: true)
      flash[:alert] = "#{object.class} #{object.id} with name '#{object.name}' is now enabled."
    end
  end
end
