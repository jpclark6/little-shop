class Admin::ItemsController < ApplicationController
  def index
    merchant = User.find(params[:merchant_id])
    @items = merchant.items
    render template: "/dashboard/items/index"
  end
end
