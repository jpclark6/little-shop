require 'rails_helper'

describe "when user adds songs to their cart" do
  it 'the message correctly increments for multiple songs' do
    item = FactoryBot.create(:item)

    visit item_path(item)

    click_button "Add Item"

    expect(page).to have_content("You now have 1 copy of #{item.name} in your cart")

    click_button "Add Item"

    expect(page).to have_content("You now have 2 copies of #{item.name} in your cart")
  end
  it 'the total number of songs in the cart increments' do
    item = FactoryBot.create(:item)

    visit item_path(item)

    expect(page).to have_content("Cart(0)")

    click_button "Add Item"

    expect(page).to have_content("Cart(1)")

    click_button "Add Item"

    expect(page).to have_content("Cart(2)")
  end
end
