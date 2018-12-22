require 'rails_helper'


describe 'As a Merchant' do
  it 'Can see a form to add a new item' do
    user = FactoryBot.create(:merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit dashboard_items_path

    click_button 'Add Item'

    expect(current_path).to eq(dashboard_items_new_path)
save_and_open_page
    fill_in :name, with: 'New Item Name'
    fill_in :description, with: 'Here is a description of the item.'
    fill_in :image, with: 'https://vignette.wikia.nocookie.net/herewestandrp/images/1/1f/New_item.png/revision/latest?cb=20171010214012'
    fill_in :price, with: 24
    fill_in :instock_qty, with: 35

    click_button 'Create Item'

    expect(current_path).to eq(dashboard_items_path)

    expect(page).to have_content(Item.last.name)
  end
end

# Run this command below
# change_column :items, :image, :string, :default => "/no_image_available.jpg"

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

# in items class validates greater than or equal to 1.
