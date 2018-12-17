class CartsController < ApplicationController
  def create
    
    item = Item.find(params[:item_id])
    flash[:notice] = "You now have #{item.name} in your cart."
    redirect_to items_path
  end
end
