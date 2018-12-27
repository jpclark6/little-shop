require 'rails_helper'

describe 'as a merchant on my dashboard' do
  before(:each) do
    @merchant = FactoryBot.create(:merchant)

    @item_1 = FactoryBot.create(:item, instock_qty: 600, price: 5, user: @merchant)
    @item_2 = FactoryBot.create(:item, instock_qty: 200, price: 10, user: @merchant)
    @item_3 = FactoryBot.create(:item, instock_qty: 200, price: 20, user: @merchant)
    @item_4 = FactoryBot.create(:item, instock_qty: 200, price: 40, user: @merchant)
    @item_5 = FactoryBot.create(:item, instock_qty: 200, price: 80, user: @merchant)
    @item_6 = FactoryBot.create(:item, instock_qty: 200, price: 50000, user: @merchant)

    @user_1 = FactoryBot.create(:user, city: 'Denver', state: 'CO')
    @user_1_order_1 = FactoryBot.create(:fulfilled, user: @user_1)
    @user_1_order_2 = FactoryBot.create(:fulfilled, user: @user_1)
    FactoryBot.create(:order_item, item: @item_1, price: @item_1.price, quantity: 100, fulfilled: true, order: @user_1_order_1)
    FactoryBot.create(:order_item, item: @item_1, price: @item_1.price, quantity: 100, fulfilled: true, order: @user_1_order_2)
# $1000, 200 pcs
    @user_2 = FactoryBot.create(:user, city: 'Denver', state: 'MI')
    @user_2_order_1 = FactoryBot.create(:fulfilled, user: @user_2)
    @user_2_order_2 = FactoryBot.create(:fulfilled, user: @user_2)
    @user_2_order_3 = FactoryBot.create(:fulfilled, user: @user_2)
    FactoryBot.create(:order_item, item: @item_1, price: @item_1.price, quantity: 100, fulfilled: true, order: @user_2_order_1)
    FactoryBot.create(:order_item, item: @item_2, price: @item_2.price, quantity: 105, fulfilled: true, order: @user_2_order_2)
    FactoryBot.create(:order_item, item: @item_3, price: @item_3.price, quantity: 50, fulfilled: true, order: @user_2_order_3)
# $1550, 255 pcs,

    @user_3 = FactoryBot.create(:user, city: 'Salt Lake City', state: 'UT')
    @user_3_order_1 = FactoryBot.create(:fulfilled, user: @user_3)
    @user_3_order_2 = FactoryBot.create(:fulfilled, user: @user_3)
    @user_3_order_3 = FactoryBot.create(:fulfilled, user: @user_3)
    FactoryBot.create(:order_item, item: @item_1, price: @item_1.price, quantity: 100, fulfilled: true, order: @user_3_order_1)
    FactoryBot.create(:order_item, item: @item_4, price: @item_4.price, quantity: 50, fulfilled: true, order: @user_3_order_2)
    FactoryBot.create(:order_item, item: @item_4, price: @item_4.price, quantity: 51, fulfilled: true, order: @user_3_order_3)
# $4540, 201 pcs

    @user_4 = FactoryBot.create(:user, city: 'Los Angeles', state: 'CA')
    @user_4_order_1 = FactoryBot.create(:fulfilled, user: @user_4)
    @user_4_order_2 = FactoryBot.create(:fulfilled, user: @user_4)
    FactoryBot.create(:order_item, item: @item_1, price: @item_1.price, quantity: 100, fulfilled: true, order: @user_4_order_1)
    FactoryBot.create(:order_item, item: @item_5, price: @item_5.price, quantity: 1, fulfilled: true, order: @user_4_order_2)
# $580, 101 pcs

    @user_5 = FactoryBot.create(:user, city: 'Fort Collins', state: 'CO')
    @user_5_order_1 = FactoryBot.create(:fulfilled, user: @user_5)
    @user_5_order_2 = FactoryBot.create(:fulfilled, user: @user_5)
    FactoryBot.create(:order_item, item: @item_6, price: @item_6.price, quantity: 2, fulfilled: true, order: @user_5_order_1)
    FactoryBot.create(:order_item, item: @item_1, price: @item_1.price, quantity: 100, fulfilled: true, order: @user_5_order_2)
# $100,500, 102 pcs

    @user_6 = FactoryBot.create(:user, city: 'Dallas', state: 'TX')
    @user_6_order_1 = FactoryBot.create(:pending, user: @user_6)
    FactoryBot.create(:order_item, item: @item_6, price: @item_6.price, quantity: 2, fulfilled: false, order: @user_6_order_1)
# 0
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

  end
  it 'can find top 5 items sold by quantity' do
    visit dashboard_path
    within('.statistics') do
      expected = "Top items sold by quantity: #{@item_1.name}, #{@item_2.name}, #{@item_4.name}, #{@item_3.name}, & #{@item_6.name}"
      expect(page).to have_content(expected)
    end
  end
  it 'can find percentage sold against total inventory' do
    visit dashboard_path
    within(".statistics") do
      expect(page).to have_content("Sold 859 items, which is 35% of your total inventory")
    end
  end
  it 'can find top 3 states where items were shipped' do
    visit dashboard_path
    within('.statistics') do
      expect(page).to have_content("Top 3 states by quantity shipped: CO, MI, & UT")
    end
    # CO, MI, UT
  end
  it 'can find top 3 city/states where items were shipped' do
    visit dashboard_path
    within('.statistics') do
      expect(page).to have_content("Top 3 city/states by quantity shipped: Denver, MI; Salt Lake City, UT; & Denver, CO")
    end
    # Denver, MO, Salt Lake City, UT, Denver, CO
  end
  it 'can find name of user with most orders' do
    visit dashboard_path
    within('.statistics') do
      expect(page).to have_content("Top customer by most orders: #{@user_2.name}")
    end
    # @user_2 or @user_3 # choose one for tie
  end
  it 'can find name of user who bought most total items' do
    visit dashboard_path
    within('.statistics') do
      expect(page).to have_content("Top customer by most items ordered: #{@user_2.name}")
    end
    # @user_2 # choose one for tie
  end
  it 'can find top 3 users who have spent the most money on items' do
    visit dashboard_path
    within('.statistics') do
      expect(page).to have_content("Top customers by total money spent: #{@user_5.name}, #{@user_3.name}, & #{@user_2.name}")
    end
    # @user_5, @user_3, @user_2
  end
end
