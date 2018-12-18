require 'rails_helper'

#still needs an add to cart button
#still needs amount of time it takes to fulfill an order

describe "user sees an item" do
  it "user sees item attributes" do
    merchant = FactoryBot.create(:merchant)
    item_1 = FactoryBot.create(:item)
    item_2 = FactoryBot.create(:item)

    visit item_path(item_1)

    expect(page).to have_content(item_1.name)
    expect(page).to have_css("img[src='#{item_1.image}']")
    expect(page).to have_content(item_1.price)
    expect(page).to have_content(item_1.instock_qty)
    expect(page).to have_content(item_1.description)
    expect(page).to have_content(merchant.name)
    expect(page).to_not have_content(item_2.name)
  end
end
