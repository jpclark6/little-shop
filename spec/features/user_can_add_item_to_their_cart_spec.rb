require 'rails_helper'

describe "when user adds items to their cart" do
  it 'the message correctly increments for multiple copies of one item' do
    item = FactoryBot.create(:item)

    visit item_path(item)
    click_button "Add Item"

    expect(page).to have_content("You now have 1 copy of #{item.name} in your cart")
    expect(current_path).to eq(items_path)

    visit item_path(item)
    click_button "Add Item"

    expect(page).to have_content("You now have 2 copies of #{item.name} in your cart")
    expect(page).to have_content("Cart(2)")
    expect(current_path).to eq(items_path)
  end
  it 'the message correctly increments for multiple items' do
    item_1 = FactoryBot.create(:item)
    item_2 = FactoryBot.create(:item)

    visit item_path(item_1)
    click_button "Add Item"

    expect(page).to have_content("You now have 1 copy of #{item_1.name} in your cart")
    expect(current_path).to eq(items_path)

    visit item_path(item_2)
    click_button "Add Item"

    expect(page).to have_content("You now have 1 copy of #{item_2.name} in your cart")
    expect(page).to have_content("Cart(2)")
    expect(current_path).to eq(items_path)
  end


  it 'the total number of items in the cart increments' do
    item = FactoryBot.create(:item)
    visit item_path(item)
    expect(page).to have_content("Cart(0)")

    visit item_path(item)
    click_button "Add Item"
    expect(page).to have_content("Cart(1)")

    visit item_path(item)
    click_button "Add Item"
    expect(page).to have_content("Cart(2)")
  end
end
