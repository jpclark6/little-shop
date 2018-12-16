require 'rails_helper'

describe 'As any type of user' do
  it 'displays all items' do
    name = 'Thing 1'
    instock_qty = 27
    price = 44
    image = 'fgkfgkjd'
    description = 'this thing is....'

    binding.pry
    visit items_path

    item_1 = FactoryBot.create(:item, name: name, instock_qty: instock_qty, price: price, image: image, description: description)
    within "#item-#{item_1.id}" do

      expect(page).to have_content(item_1.name)
      expect(page).to have_content(item_1.merchant.name)
      expect(page).to have_content(item_1.instock_qty)
      expect(page).to have_content(item_1.price)
      expect(page).to have_css("img[src='#{item_1.image}']")
      expect(page).to have_content(item_1.description)
    end

  end

end
