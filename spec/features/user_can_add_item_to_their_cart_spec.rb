require 'rails_helper'

describe "when user adds songs to their cart" do
  it 'the message correctly increments for multiple songs' do
    user = FactoryBot.build_stubbed(:user)
    item = FactoryBot.create(:item)

    visit items_path

    click_button "Add Item"

    expect(page).to have_content("You now have 1 copy of #{item.name} in your cart")

    click_button "Add Item"

    expect(page).to have_content("You now have 2 copies of #{item.name} in your cart")
  end
  it 'the total number of songs in the cart increments' do
    user = FactoryBot.build_stubbed(:user)
    item = FactoryBot.create(:item)

    visit items_path

    expect(page).to have_content("Cart: 0")

    click_button "Add Item"

    expect(page).to have_content("Cart: 1")

    click_button "Add Item"

    expect(page).to have_content("Cart: 2")
  end
end
