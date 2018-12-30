require 'rails_helper'

#still needs an add to cart button
#still needs amount of time it takes to fulfill an order

describe "user sees an item" do
  it "user sees item attributes" do
    item_1 = FactoryBot.create(:item)
    user_1 = FactoryBot.create(:user)
    order_1 = item_1.orders.create(user: user_1)
    order_2 = item_1.orders.create(user: user_1)
    unfulfilled_order = item_1.orders.create(user: user_1)

    order_1.order_items.first.update(fulfilled: true, created_at: 0.4.hours.ago)
    order_2.order_items.first.update(fulfilled: true, created_at: 3.days.ago)
    unfulfilled_order.order_items.first.update(fulfilled: false, created_at: 21.days.ago)

    item_2 = FactoryBot.create(:item)

    visit item_path(item_1)

    expect(page).to have_content(item_1.name)
    expect(page).to have_css("img[src='#{item_1.image}']")
    expect(page).to have_content(item_1.price)
    expect(page).to have_content(item_1.instock_qty)
    expect(page).to have_content(item_1.description)
    expect(page).to have_content(item_1.user.name)
    expect(page).to have_content("Average Time to Fulfill Item: 1 day 12:12:00")

    expect(page).to_not have_content(item_2.name)
  end
end
