require 'rails_helper'

describe "when user adds songs to their cart" do
  it "a message is displayed" do
    user = FactoryBot.build_stubbed(:user)
    item = FactoryBot.create(:item)

    visit items_path

    click_button "Add Item"

    expect(page).to have_content("You now have #{item.name} in your cart")
  end
end
