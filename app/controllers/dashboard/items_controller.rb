class Dashboard::ItemsController < ApplicationController
  def index
    @items = Item.where(user: current_user)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:message] = "Your new item is saved."
      redirect_to dashboard_items_path
    else
      add_errors_on_flash(@item)
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      flash[:success] = "Item #{@item.id} '#{@item.name}' has been updated."

      redirect_to dashboard_items_path
    else
      add_errors_on_flash(@item)
      render :edit
    end
  end


  def toggle
    item = Item.find(params[:id])
    toggle_enabled(item)
    redirect_to dashboard_items_path
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    flash[:alert] = "Item #{item.id} with name '#{item.name}' has been deleted."
    redirect_to dashboard_items_path
  end
  private

  def item_params
    ip = params.require(:item).permit(:name, :description, :image, :price, :instock_qty)
    ip[:user] = current_user
    ip.delete(:image) if ip[:image].empty?
    ip
  end
end
