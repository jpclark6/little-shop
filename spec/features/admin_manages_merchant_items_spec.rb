require 'rails_helper'

describe "as an admin" do
  before(:each) do

    @new_name = 'New Item Name'
    @new_description = 'Here is a description of the item.'
    @new_image ='https://vignette.wikia.nocookie.net/herewestandrp/images/1/1f/New_item.png/revision/latest?cb=20171010214012'
    @new_price =24
    @new_instock_qty =35

    admin = FactoryBot.create(:admin)
    @merchant = FactoryBot.create(:merchant)

    @item_1 = FactoryBot.create(:item)
    @item_2 = FactoryBot.create(:item, enabled: false)

    @item_2.orders << FactoryBot.create(:fulfilled)
    @merchant.items += [@item_1, @item_2]

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit admin_merchant_path(@merchant)

    click_on "View Items"
  end

  it "I can view a merchant's items just like that merchant would" do
    expect(current_path).to eq(admin_merchant_items_path(@merchant))
    within "#item-#{@item_1.id}" do
      expect(page).to have_content("ID: #{@item_1.id}")
      expect(page).to have_content(@item_1.name)
      expect(page).to have_css("img[src='#{@item_1.image}']")
      expect(page).to have_content("$#{@item_1.price}")
      expect(page).to have_content("In stock: #{@item_1.instock_qty}")

      expect(page).to have_button("Edit Item")
      expect(page).to have_button("Delete Item")
      expect(page).to have_button("Disable Item")
      expect(page).to_not have_button("Enable Item")

    end

    within "#item-#{@item_2.id}" do
      expect(page).to have_content("ID: #{@item_2.id}")
      expect(page).to have_content(@item_2.name)
      expect(page).to have_css("img[src='#{@item_2.image}']")
      expect(page).to have_content("$#{@item_2.price}")
      expect(page).to have_content("In stock: #{@item_2.instock_qty}")

      expect(page).to have_button("Edit Item")
      expect(page).to_not have_button("Delete Item")
      expect(page).to have_button("Enable Item")
    end
  end

  it "I can enable, disable, and delete a merchant's items" do
    within "#item-#{@item_1.id}" do
      click_on "Disable Item"
    end

    expect(current_path).to eq admin_merchant_items_path(@merchant)
    expect(page).to have_content("Item #{@item_1.id} with name '#{@item_1.name}' is now disabled.")

    within "#item-#{@item_1.id}" do
      expect(page).to have_content("Status: Disabled")
    end


    within "#item-#{@item_2.id}" do
      click_on "Enable Item"
    end

    expect(current_path).to eq admin_merchant_items_path(@merchant)
    expect(page).to have_content("Item #{@item_2.id} with name '#{@item_2.name}' is now enabled.")

    within "#item-#{@item_2.id}" do
      expect(page).to have_content("Status: Enabled")
    end

    within "#item-#{@item_1.id}" do
      click_on "Delete Item"
    end

    expect(current_path).to eq admin_merchant_items_path(@merchant)
    expect(page).to have_content("Item #{@item_1.id} with name '#{@item_1.name}' has been deleted.")

    expect(page).to_not have_css("#item-#{@item_1.id}")
  end
  describe "I can add an item" do
    before(:each) do
      click_on 'Add Item'
      expect(current_path).to eq(new_admin_merchant_item_path(@merchant))

      fill_in :item_name, with: @new_name
      fill_in :item_description, with: @new_description
      fill_in :item_image, with: @new_image
      fill_in :item_price, with: @new_price
      fill_in :item_instock_qty, with: @new_instock_qty
    end
    it 'with proper data' do

      click_button 'Create Item'

      expect(current_path).to eq admin_merchant_items_path(@merchant)


      within "#item-#{Item.last.id}" do
        expect(page).to have_content(@new_name)
        expect(page).to have_content(@new_description)
        expect(page).to have_css("img[src='#{@new_image}']")
        expect(page).to have_content("$#{@new_price}")
        expect(page).to have_content("In stock: #{@new_instock_qty}")
        expect(page).to have_content("Status: Enabled")
      end
    end
    it 'with bad data' do
      fill_in :item_name, with: ""
      fill_in :item_description, with: ""
      fill_in :item_price, with: -10.99
      fill_in :item_instock_qty, with: 0.1

      click_on "Create Item"
      expect(page).to have_content("Item price must be greater than 0.")
      expect(page).to have_content("Item instock_qty must be an integer.")
      expect(page).to have_content("Item name can't be blank.")
      expect(page).to have_content("Item description can't be blank.")

      fill_in :item_instock_qty, with: -3

      click_on "Create Item"

      expect(page).to have_content("Item instock_qty must be greater than or equal to 0.")
    end
  end
  describe "I can edit an item" do
    before(:each) do

      within "#item-#{@item_1.id}" do
        click_on "Edit Item"
      end
    end

    it 'with proper data' do

      expect(current_path).to eq(edit_admin_item_path(@item_1))

      expect(find_field(:item_name).value).to eq(@item_1.name)
      expect(find_field(:item_image).value).to eq("")
      expect(find_field(:item_description).value).to eq(@item_1.description)
      expect(find_field(:item_price).value).to eq(@item_1.price.to_s)
      expect(find_field(:item_instock_qty).value).to eq(@item_1.instock_qty.to_s)

      fill_in :item_name, with: @new_name
      fill_in :item_description, with: @new_description
      fill_in :item_image, with: @new_image
      fill_in :item_price, with: @new_price
      fill_in :item_instock_qty, with: @new_instock_qty

      click_on "Update Item"

      expect(current_path).to eq(admin_merchant_items_path(@merchant))

      within "#item-#{@item_1.id}" do
        expect(page).to have_content(@new_name)
        expect(page).to have_content(@new_description)
        expect(page).to have_css("img[src='#{@new_image}']")
        expect(page).to have_content("$#{@new_price}")
        expect(page).to have_content("In stock: #{@new_instock_qty}")
        expect(page).to have_content("Status: Enabled")
      end
    end

    it 'with bad data' do
      fill_in :item_name, with: ""
      fill_in :item_description, with: ""
      fill_in :item_price, with: -10.99
      fill_in :item_instock_qty, with: 0.1

      click_on "Update Item"
      expect(page).to have_content("Item price must be greater than 0.")
      expect(page).to have_content("Item instock_qty must be an integer.")
      expect(page).to have_content("Item name can't be blank.")
      expect(page).to have_content("Item description can't be blank.")

      fill_in :item_instock_qty, with: -3

      click_on "Update Item"

      expect(page).to have_content("Item instock_qty must be greater than or equal to 0.")
    end

  end

end
