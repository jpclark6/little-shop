require 'rails_helper'


describe 'As a Merchant' do
  xit 'Can see a form to add a new item' do
    user = FactoryBot.create(:merchant)
    item = FactoryBot.create(:item)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit dashboard_items_path

    click_button "Add Item"

    expect(current_path).to eq(dashboard_items_new_path)

    fill_in item
    # do I need to give the item an order???? DOn't think so.
  end
end

# User Story 54
# Merchant adds an item
# As a merchant
# When I visit my items page
# >>>>>>
# And I click on the link to add a new item
#>>>>
# My URI route should be "/dashboard/items/new"
# >>>>>>>>>>>

# I see a form where I can add new information about an item, including:

# - the name of the item, which cannot be blank
# - a description for the item, which cannot be blank
# - a thumbnail image URL string, which CAN be left blank
# - a price which must be greater than $0.00
# - my current inventory count of this item which is 0 or greater

# When I submit valid information and save the form
# I am taken back to my items page
# I see a flash message indicating my new item is saved
# I see the new item on the page, and it is enabled and available for sale
# If I left the image field blank, I see a placeholder image for the thumbnail
