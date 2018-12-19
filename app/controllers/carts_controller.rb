class CartsController < ApplicationController
  include ActionView::Helpers::TextHelper

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

end
