require "rails_helper"

describe 'merchant item index page' do
  context "as a merchant" do
    it 'displays my items' do

      merchant = FactoryBot.create(:merchant)
      item_1 = FactoryBot.create(:item)
      item_2 = FactoryBot.create(:item)
      merchant.items += [item_1, item_2]

      visit "/dashboard/items"

      within "#item-#{item_1.id}"
      expect(page).to have_content("id: #{item_1.id}")
      expect(page).to have_content(item_1.name)
      expect(page).to have_css("img[src='#{item_1.image}']")
      expect(page).to have_content("$#{item_1.price}")
      expect(page).to have_content("in stock: #{item_1.instock_qty}")
      expect(page).to have_button("Edit Item")

    end

  end
end

# As a merchant
# When I visit my items page "/dashboard/items"
# I see a link to add a new item to the system
# I see each item I have already added to the system, including:
# - the ID of the item
# - the name of the item
# - a thumbnail image for that item
# - the price of that item
# - my current inventory count for that item
# - a link or button to edit the item
#
# If no user has ever ordered this item, I see a link to delete the item
# If the item is enabled, I see a button or link to disable the item
# If the item is disabled, I see a button or link to enable the item
