class Admin::ItemsController < ApplicationController
  def new
    @merchant = User.find(params[:merchant_id])
    @item = Item.new
  end



  def create
    @merchant = User.find(params[:merchant_id])
    @item = Item.new(item_params)
    if @item.save
      flash[:message] = "Item is saved."
      redirect_to admin_merchant_items_path(@merchant)
    else
      add_errors_on_flash(@item)
      render :new
    end
  end

  def index
    @merchant = User.find(params[:merchant_id])
    @items = @merchant.items
    render template: "/dashboard/items/index"
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      flash[:success] = "Item #{@item.id} '#{@item.name}' has been updated."
      redirect_to admin_merchant_items_path(@item.user)
    else
      add_errors_on_flash(@item)
      render :edit
    end
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

  private

  def item_params
    ip = params.require(:item).permit(:name, :description, :image, :price, :instock_qty)
    ip[:user] = @merchant || @item.user
    ip.delete(:image) if ip[:image].empty?
    ip
  end
end
