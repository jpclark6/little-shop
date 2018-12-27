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
    @user_2 = FactoryBot.create(:user, city: 'Denver', state: 'MO')
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
      expected = "Top items sold by quantity: #{@item_1.name}, #{@item_2.name}, #{@item_3.name}, #{@item_4.name}, & #{@item_5.name}"
      expect(page).to have_content(expected)
    end
    # @item_1, @item_2, @item_4, @item_3, @item_6
  end
  it 'can find percentage sold against total inventory' do
    visit dashboard_path
    within('.statistics') do
      within(".item-#{@item_1}") do
        expect(page).to have_content("Sold 500 items, which is 50% of your total inventory")
      end
    end
    # @item_1 - 50%
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
      expect(page).to have_content("Top 3 city/states by quantity shipped: Denver, MO; Salt Lake City, UT; & Denver, CO")
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


# When I visit my dashboard, I see an area with statistics:
# - top 5 items I have sold by quantity
# - total quantity of items I've sold, and as a percentage against my sold units plus remaining inventory (eg, if I have sold 1,000 things and still have 9,000 things in inventory, the message would say something like "Sold 1,000 items, which is 10% of your total inventory")
# - top 3 states where my items were shipped
# - top 3 city/state where my items were shipped (Springfield, MI should not be grouped with Springfield, CO)
# - name of the user with the most orders from me (pick one if there's a tie)
# - name of the user who bought the most total items from me (pick one if there's a tie)
# - top 3 users who have spent the most money on my items
