require "rails_helper"
describe 'order show page' do
  context 'as a merchant' do
    it "shows the customer's name and address" do
      merchant = FactoryBot.create(:merchant)
      item = FactoryBot.create(:item)
      merchant.items << item

      customer = FactoryBot.create(:user)

      order = FactoryBot.create(:order, items: [item], user: customer)


      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit dashboard_path
      click_on "#{order.id}"
      expect(current_path).to eq(dashboard_order_path(order))

      expect(page).to have_content(customer.name)
      expect(page).to have_content(customer.address)
      expect(page).to have_content(customer.city)
      expect(page).to have_content(customer.state)
      expect(page).to have_content(customer.zip_code)
    end
    it 'shows my items and no others from the order' do
      merchant = FactoryBot.create(:merchant)
      item_1 = FactoryBot.create(:item)
      item_2 = FactoryBot.create(:item)
      merchant.items << item_1

      customer = FactoryBot.create(:user)
      order = FactoryBot.create(:order, items: [item_1, item_2], user: customer)


      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit dashboard_order_path(order)
      expect(page).to have_css("item-#{item_1.id}")
      expect(page).to_not have_css("item-#{item_2.id}")
    end
  end

end



# When I visit an order show page from my dashboard
# I only see the items in the order that are being purchased from my inventory
# I do not see any items in the order being purchased from other merchants
# For each item, I see the following information:
# - the name of the item, which is a link to my item's show page
# - a small thumbnail of the item
# - my price for the item
# - the quantity the user wants to purchase
