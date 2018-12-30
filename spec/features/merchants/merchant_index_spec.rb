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
    it "I see the 3 merchants that have sold the most by revenue" do
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

      within (".top_revenue") do
        expect(page).to have_content("Top 3 merchants by revenue")
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
      order_item_6 = FactoryBot.create(:order_item, updated_at: 13.days.ago, created_at: 15.days.ago, fulfilled: true, item: item_3)

      order_item_7 = FactoryBot.create(:order_item, updated_at: 20.days.ago, created_at: 25.days.ago, fulfilled: true)
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
    it 'I see the 3 slowest merchants at fulfilling orders' do
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
      order_item_6 = FactoryBot.create(:order_item, updated_at: 13.days.ago, created_at: 15.days.ago, fulfilled: true, item: item_3)

      order_item_7 = FactoryBot.create(:order_item, updated_at: 20.days.ago, created_at: 25.days.ago, fulfilled: true)
      merchant_4 = order_item_7.item.user
      item_4 = FactoryBot.create(:item, user: merchant_4)
      order_item_8 = FactoryBot.create(:order_item, updated_at: 3.days.ago, created_at: 6.days.ago, fulfilled: true, item: item_4)

      visit merchants_path

      within ".slowest_fulfillment" do
        expect(page).to have_content("Slowest merchants")
        expect(all("li")[0]).to have_content(merchant_1.name)
        expect(all("li")[1]).to have_content(merchant_4.name)
        expect(all("li")[2]).to have_content(merchant_3.name)
        expect(page).to_not have_content(merchant_2.name)
      end
    end
    it 'I see the 3 biggest orders by quantity' do
      order_1 = FactoryBot.create(:order)
      order_item_1 = FactoryBot.create(:order_item, order: order_1, quantity: 5)

      order_2 = FactoryBot.create(:order)
      order_item_2 = FactoryBot.create(:order_item, order: order_2, quantity: 15)

      order_3 = FactoryBot.create(:order)
      order_item_3 = FactoryBot.create(:order_item, order: order_3, quantity: 7)

      order_4 = FactoryBot.create(:order)
      order_item_4 = FactoryBot.create(:order_item, order: order_4, quantity: 2)


      visit merchants_path

      within ".biggest_orders" do
        expect(page).to have_content("Biggest orders")
        expect(all("li")[0]).to have_content("Order id: #{order_2.id}")
        expect(all("li")[1]).to have_content("Order id: #{order_3.id}")
        expect(all("li")[2]).to have_content("Order id: #{order_1.id}")
        expect(page).to_not have_content("Order id: #{order_4.id}")
      end
    end
    it 'top 3 states where any orders were shipped' do
      user_1 = FactoryBot.create(:user, state:"MI")
      order_1 = FactoryBot.create(:order, user: user_1, status: "fulfilled")
      order_2 = FactoryBot.create(:order, user: user_1, status: "fulfilled")
      order_3 = FactoryBot.create(:order, user: user_1, status: "pending")

      user_2 = FactoryBot.create(:user, state:"MI")
      order_4 = FactoryBot.create(:order, user: user_2, status: "fulfilled")
      order_5 = FactoryBot.create(:order, user: user_2, status: "pending")

      user_3 = FactoryBot.create(:user, state:"IN")
      order_6 = FactoryBot.create(:order, user: user_3, status: "fulfilled")
      order_12 = FactoryBot.create(:order, user: user_3, status: "fulfilled")

      user_4 = FactoryBot.create(:user, state:"CO")
      order_7 = FactoryBot.create(:order, user: user_4, status: "fulfilled")

      user_5 = FactoryBot.create(:user, state:"MI")
      order_8 = FactoryBot.create(:order, user: user_5, status: "fulfilled")

      user_6 = FactoryBot.create(:user, state:"CO")
      order_9 = FactoryBot.create(:order, user: user_6, status: "fulfilled")
      order_10 = FactoryBot.create(:order, user: user_6, status: "fulfilled")
      order_11 = FactoryBot.create(:order, user: user_6, status: "pending")

      user_7 = FactoryBot.create(:user, state:"FL")
      order_13 = FactoryBot.create(:order, user: user_7, status: "fulfilled")

      visit merchants_path

      within ".top_states" do
        expect(page).to have_content("Top states")
        expect(all("li")[0]).to have_content(user_1.state)
        expect(all("li")[1]).to have_content(user_6.state)
        expect(all("li")[2]).to have_content(user_3.state)
        expect(page).to_not have_content(user_7.state)
      end
    end
    it 'top 3 cities where any orders were shipped' do
      user_1 = FactoryBot.create(:user, state:"MI", city:"Detroit")
      order_1 = FactoryBot.create(:order, user: user_1, status: "fulfilled")
      order_2 = FactoryBot.create(:order, user: user_1, status: "fulfilled")
      order_3 = FactoryBot.create(:order, user: user_1, status: "pending")

      user_3 = FactoryBot.create(:user, state:"IN", city: "Indianapolis")
      order_6 = FactoryBot.create(:order, user: user_3, status: "fulfilled")
      order_12 = FactoryBot.create(:order, user: user_3, status: "fulfilled")
      order_14 = FactoryBot.create(:order, user: user_3, status: "fulfilled")


      user_5 = FactoryBot.create(:user, state:"MI", city: "Detroit")
      order_8 = FactoryBot.create(:order, user: user_5, status: "fulfilled")

      user_6 = FactoryBot.create(:user, state:"CO", city: "Detroit")
      order_9 = FactoryBot.create(:order, user: user_6, status: "fulfilled")
      order_10 = FactoryBot.create(:order, user: user_6, status: "fulfilled")
      order_11 = FactoryBot.create(:order, user: user_6, status: "pending")

      user_7 = FactoryBot.create(:user, state:"FL", city: "Miami")
      order_13 = FactoryBot.create(:order, user: user_7, status: "fulfilled")

      visit merchants_path

      within ".top_cities" do
        expect(page).to have_content("Top cities")
        expect(all("li")[0]).to have_content(user_1.city)
        expect(all("li")[1]).to have_content(user_3.city)
        expect(all("li")[2]).to have_content(user_5.city)
        expect(page).to_not have_content(user_7.city)
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
