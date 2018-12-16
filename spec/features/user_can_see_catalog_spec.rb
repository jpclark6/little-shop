require 'rails_helper'

describe 'As any type of user' do
  it 'displays all items' do

    item_1 = FactoryBot.create(:item)
    item_2 = FactoryBot.create(:item)
    visit items_path

    within "#item-#{item_1.id}" do
      expect(page).to have_content(item_1.name)
      expect(page).to have_content(item_1.user.name)
      expect(page).to have_content(item_1.instock_qty)
      expect(page).to have_content(item_1.price)
      expect(page).to have_css("img[src='#{item_1.image}']")
      expect(page).to have_content(item_1.description)
    end

    within "#item-#{item_2.id}" do
      expect(page).to have_content(item_2.name)
      expect(page).to have_content(item_2.user.name)
      expect(page).to have_content(item_2.instock_qty)
      expect(page).to have_content(item_2.price)
      expect(page).to have_css("img[src='#{item_2.image}']")
      expect(page).to have_content(item_2.description)
    end

  end
  it "links to the items show page with the item name" do
    item_1 = FactoryBot.create(:item)

    visit items_path

    click_on(item_1.name)
    expect(current_path).to eq(item_path(item_1))
  end

  it "links to the items show page with the item name" do
    item_1 = FactoryBot.create(:item)

    visit items_path
    save_and_open_page
    within "#item-#{item_1.id}" do
      click_on("No image available")
    end
    expect(current_path).to eq(item_path(item_1))
  end
end
