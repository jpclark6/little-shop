class Dashboard::ItemsController < ApplicationController

  def index
    @items = Item.where(user: current_user)
  end

end
