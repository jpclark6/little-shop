require "rails_helper"

describe 'merchant index page' do
  context 'as a visitor' do
    it 'I see active merchants, their city, state and their registration date' do
      merchant_1 = FactoryBot.create(:merchant)
      merchant_2 = FactoryBot.create(:merchant)
      merchant_3 = FactoryBot.create(:merchant, :disabled)

      visit merchants_path

      within "#merchant-#{merchant_1.id}" do
        expect(page).to have_content(merchant_1.name)
        expect(page).to have_content(merchant_1.city)
        expect(page).to have_content(merchant_1.state)
        expect(page).to have_content(merchant_1.created_at.to_date)
      end

      within "#merchant-#{merchant_2.id}" do
        expect(page).to have_content(merchant_2.name)
        expect(page).to have_content(merchant_2.city)
        expect(page).to have_content(merchant_2.state)
        expect(page).to have_content(merchant_2.created_at.to_date)
      end

      expect(page).to_not have_css("#merchant-#{merchant_3.id}")
      expect(page).to_not have_button("Disable")
      expect(page).to_not have_button("Enable")
    end
    it "I see the 3 merchants that have sold the most by quantity" do
      order_item_1= FactoryBot.create(:order_item, quantity: 5, fulfilled: true)
      merchant_1 = order_item_1.item.user

      order_item_2= FactoryBot.create(:order_item, quantity: 10, fulfilled: true)
      merchant_2 = order_item_2.item.user

      order_item_3= FactoryBot.create(:order_item, quantity: 2, fulfilled: true)
      merchant_3 = order_item_3.item.user

      order_item_4= FactoryBot.create(:order_item, quantity: 1, fulfilled: true)
      merchant_4 = order_item_4.item.user
      item_4 = FactoryBot.create(:item, user: merchant_4)
      order_item_5= FactoryBot.create(:order_item, quantity: 3, item: item_4, fulfilled: true)

      visit merchants_path

      within (".top_quantity") do
        expect(page).to have_content("Top 3 merchants by quantity")
        expect(page).to have_content(merchant_2.name)
        expect(page).to have_content(merchant_1.name)
        expect(page).to have_content(merchant_4.name)
        expect(page).to_not have_content(merchant_3.name)
      end
    end
    it "I see the 3 merchants that have sold the most by price" do
      order_item_1= FactoryBot.create(:order_item, price: 5.0, fulfilled: true)
      merchant_1 = order_item_1.item.user

      order_item_2= FactoryBot.create(:order_item, price: 10.0, fulfilled: true)
      merchant_2 = order_item_2.item.user

      order_item_3= FactoryBot.create(:order_item, price: 2.5, fulfilled: true)
      merchant_3 = order_item_3.item.user

      order_item_4= FactoryBot.create(:order_item, price: 1.8, fulfilled: true)
      merchant_4 = order_item_4.item.user
      item_4 = FactoryBot.create(:item, user: merchant_4)
      order_item_5= FactoryBot.create(:order_item, price: 3.5, item: item_4, fulfilled: true)

      visit merchants_path

      within (".top_price") do
        expect(page).to have_content("Top 3 merchants by price")
        expect(page).to have_content(merchant_2.name)
        expect(page).to have_content(merchant_4.name)
        expect(page).to have_content(merchant_1.name)
        expect(page).to_not have_content(merchant_3.name)
      end
    end
    it 'I see the 3 fastest merchants at fulfilling orders' do
      order_item_1 = FactoryBot.create(:order_item, updated_at: 1.days.ago, created_at: 10.days.ago, fulfilled: true)
      merchant_1 = order_item_1.item.user
      item_1 = FactoryBot.create(:item, user: merchant_1)
      order_item_2 = FactoryBot.create(:order_item, updated_at: Date.current, created_at: 7.days.ago, fulfilled: true, item: item_1)

      order_item_3 = FactoryBot.create(:order_item, updated_at: Date.current, created_at: 1.days.ago, fulfilled: true)
      merchant_2 = order_item_3.item.user
      item_2 = FactoryBot.create(:item, user: merchant_2)
      order_item_4 = FactoryBot.create(:order_item, updated_at: 3.days.ago, created_at: 5.days.ago, fulfilled: true, item: item_2)

      order_item_5 = FactoryBot.create(:order_item, updated_at: 4.days.ago, created_at: 7.days.ago, fulfilled: true)
      merchant_3 = order_item_5.item.user
      item_3 = FactoryBot.create(:item, user: merchant_3)
      order_item_6 = FactoryBot.create(:order_item, updated_at: 15.days.ago, created_at: 13.days.ago, fulfilled: true, item: item_3)

      order_item_7 = FactoryBot.create(:order_item, updated_at: 25.days.ago, created_at: 20.days.ago, fulfilled: true)
      merchant_4 = order_item_7.item.user
      item_4 = FactoryBot.create(:item, user: merchant_4)
      order_item_8 = FactoryBot.create(:order_item, updated_at: 3.days.ago, created_at: 6.days.ago, fulfilled: true, item: item_4)

      visit merchants_path

      within ".fastest_fulfillment" do
        expect(page).to have_content("Fastest merchants")
        expect(all("li")[0]).to have_content(merchant_2.name)
        expect(all("li")[1]).to have_content(merchant_3.name)
        expect(all("li")[2]).to have_content(merchant_4.name)
        expect(page).to_not have_content(merchant_1.name)
      end
    end
  end
  context "as an admin" do
    it 'I see merchant info, their names are links, and I see buttons to enable or disable them' do
      admin = FactoryBot.create(:admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      merchant_1 = FactoryBot.create(:merchant)
      merchant_2 = FactoryBot.create(:merchant, :disabled)

      visit merchants_path

      within "#merchant-#{merchant_1.id}" do
        expect(page).to have_content(merchant_1.name)
        expect(page).to have_content(merchant_1.city)
        expect(page).to have_content(merchant_1.state)
        expect(page).to have_content(merchant_1.created_at.to_date)
        expect(page).to have_button("Disable")
      end

      within "#merchant-#{merchant_2.id}" do
        expect(page).to have_content(merchant_2.name)
        expect(page).to have_content(merchant_2.city)
        expect(page).to have_content(merchant_2.state)
        expect(page).to have_content(merchant_2.created_at.to_date)
        expect(page).to have_button("Enable")

      end

    end
  end
end


# As an admin user
# When I visit the merchant's index page at "/merchants"
# I see all merchants in the system
# Next to each merchant's name I see their city and state
# The merchant's name is a link to their Merchant Dashboard at routes such as "/admin/merchants/5"
# I see a "disable" button next to any merchants who are not yet disabled
# I see an "enable" button next to any merchants whose accounts are disabled
