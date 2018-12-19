class ItemsController < ApplicationController
  def index
    if current_user && current_user.merchant? && request.env['PATH_INFO']
      @items = current_user.items
    else
      @items = Item.where(enabled: true)
    end
  end

  def show
    @item = Item.find(params[:id])
  end
end
