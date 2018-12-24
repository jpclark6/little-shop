class Admin::ItemsController < ApplicationController
  def index
    merchant = User.find(params[:merchant_id])
    @items = merchant.items
    render template: "/dashboard/items/index"
  end

  def toggle
    item = Item.find(params[:id])
    toggle_enabled(item)
    redirect_to admin_merchant_items_path(item.user)
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    flash[:alert] = "Item #{item.id} with name '#{item.name}' has been deleted."
    redirect_to admin_merchant_items_path(item.user)
  end
end
