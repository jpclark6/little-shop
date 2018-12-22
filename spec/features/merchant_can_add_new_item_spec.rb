require 'rails_helper'


describe 'As a Merchant' do
  before(:each) do
    user = FactoryBot.create(:merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit dashboard_items_path

    click_button 'Add Item'

    expect(current_path).to eq(dashboard_items_new_path)

    fill_in :item_name, with: 'New Item Name'
    fill_in :item_description, with: 'Here is a description of the item.'
    fill_in :item_image, with: 'https://vignette.wikia.nocookie.net/herewestandrp/images/1/1f/New_item.png/revision/latest?cb=20171010214012'
    fill_in :item_price, with: 24
    fill_in :item_instock_qty, with: 35
  end
  it 'Can see a form to add a new item' do

    click_button 'Create Item'

    expect(current_path).to eq(dashboard_items_path)

    expect(page).to have_content(Item.last.name)
    expect(page).to have_content(Item.last.description)
    expect(page).to have_css("img[src='#{Item.last.image}']")
    expect(page).to have_content("Price: $#{Item.last.price}")
    expect(page).to have_content("In stock: #{Item.last.instock_qty}")
  end

  it 'Form gives errors when name & description field blank' do
    fill_in :item_name, with: ''
    fill_in :item_description, with: ''

    click_button 'Create Item'

    expect(page).to have_content("name can't be blank")
    expect(page).to have_content("description can't be blank")
  end

  it 'Form gives errors when price & instock_qty field blank' do
    fill_in :item_price, with: ''
    fill_in :item_instock_qty, with: ''

    click_button 'Create Item'

    expect(page).to have_content("Item price can't be blank")
    expect(page).to have_content("Item instock_qty can't be blank")
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

# in items class validates greater than or equal to 1.
