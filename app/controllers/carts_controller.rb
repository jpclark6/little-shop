class CartsController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :no_merchants_allowed
  before_action :no_admins_allowed

  def create
    item = Item.find(params[:item_id])
    @cart.add_item(item.id)
    session[:cart] = @cart.contents
    quantity = @cart.count_of(item.id)
    flash[:notice] = "You now have #{pluralize(quantity, "copy")} of #{item.name} in your cart."
    redirect_to items_path
  end

  def show
  end

  def delete
    session[:cart] = {}
    @cart.empty_cart
    redirect_to cart_path
  end

  def update
    item = Item.find(params[:item_id])
    if params[:change_quantity] == "+"
      unless @cart.qty(item) == item.instock_qty
        @cart.add_item(item.id)
      else
        flash[:notice] = "Max quantity reached on item due to inventory availability"
      end
    elsif params[:change_quantity] == "-"
      @cart.remove_item(item.id)
    elsif params[:change_quantity] == "0"
      @cart.delete_item(item.id)
    end
    redirect_to cart_path
  end


end
