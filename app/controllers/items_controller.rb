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

  # def create
  #   @item = Item.create(item_params)
  #   redirect_to dashboard_items_path
  # end
  #
  #   # def show
  #   #   @new_item = Item.last
  #   # end
  # 
  #   private
  #
  #   def item_params
  #   params.require(:item).permit(:name)
  #   end
end
