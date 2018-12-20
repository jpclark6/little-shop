require 'rails_helper'

describe 'As a user' do
  before(:each) do
    @user_1, @user_2 = FactoryBot.create_list(:user, 2)
    @merchant = FactoryBot.create(:merchant)
    @other_merchant = FactoryBot.create(:merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    @order_1 = @user_1.orders.create(status: 'pending')
    @order_2 = @user_2.orders.create(status: 'pending')
    @order_3 = @user_2.orders.create(status: 'pending')
    @item_1 = FactoryBot.create(:item)
    @item_2 = FactoryBot.create(:item)
    @item_3 = FactoryBot.create(:item)
    @item_4 = FactoryBot.create(:item)
    @item_5 = FactoryBot.create(:item)
    @item_6 = FactoryBot.create(:item)
    @item_7 = FactoryBot.create(:item)
    @item_8 = FactoryBot.create(:item)
    @item_9 = FactoryBot.create(:item)

    @order_1.items += [@item_1, @item_2]
    @order_2.items += [@item_3, @item_4]
    @order_3.items += [@item_5, @item_6]
  end
  describe 'when I visit and orders show page' do
    it 'should show the customers info and all of the order items' do

      visit order_path(@order_1)

      expect(page).to have_content("Order #{@order_1.id}")
      expect(page).to have_content(@user_1.name)
      expect(page).to have_content(@user_1.address)
      expect(page).to have_content("#{@user_1.city}, #{@user_1.state} #{@user_1 .zip_code}")
      expect(page).to have_css("img[src*='#{@item_2.image}']")
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@order_1.items.first.price)
      expect(page).to have_content(@order_1.items.first.quantity)
      expect(page).to have_content(@item_2.name)
      expect(page).to have_content(@item_3.name)
      expect(page).to have_content(@item_4.name)
      expect(page).to have_content(@item_5.name)
      expect(page).to_not have_content(@item_6.name)
      expect(page).to_not have_content(@item_7.name)
      expect(page).to_not have_content(@item_8.name)
      expect(page).to_not have_content(@item_9.name)
    end
  end
end
