class Dashboard::ItemsController < ApplicationController
  before_action :require_current_user

  def index
    @items = Item.where(user: current_user)
  end

  def toggle
    item = Item.find(params[:id])
    if item.enabled?
      item.update(enabled: false)
    else
      item.update(enabled: true)
    end
    flash[:alert] = "Item #{item.id} with name '#{item.name}' is now disabled."
    redirect_to dashboard_items_path
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    flash[:alert] = "Item #{item.id} with name '#{item.name}' has been deleted."
    redirect_to dashboard_items_path
  end

  def new
  end
end
