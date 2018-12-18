class ItemsController < ApplicationController
  def index
    @items = Item.where(enabled: true)
    @cart = Cart.new(session[:cart])
  end

  def show
    @item = Item.find(params[:id])
  end
end
