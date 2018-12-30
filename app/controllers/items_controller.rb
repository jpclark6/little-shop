class ItemsController < ApplicationController
  def index
    if merchant_user? && request.env['PATH_INFO']
      @items = current_user.items
    else
      @items = Item.where(enabled: true)
    end
    @top_5_items = Item.top_5
    @bottom_5_items = Item.bottom_5
  end

  def show
    @item = Item.find(params[:id])
  end
end
