require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :email}
    it {should validate_uniqueness_of :email}
    it {should validate_presence_of :role}
    it {should validate_presence_of :password}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip_code}
    it {should validate_confirmation_of :password}
  end
  describe 'relationships' do
    it {should have_many :items}
    it {should have_many :orders}
  end
  describe 'class methods' do
    it ".top_merch_quantity" do
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

      expect(User.top_merch_quantity).to eq([merchant_2, merchant_1, merchant_4])
    end
    it ".top_merch_price" do
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

      expect(User.top_merch_price).to eq([merchant_2, merchant_4, merchant_1])
    end
    it '.fastest_fulfillment' do
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

      expect(User.fastest_fulfillment).to eq([merchant_2, merchant_3, merchant_4])
    end
    it '.slowest_fulfillment' do
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

      expect(User.slowest_fulfillment).to eq([merchant_1, merchant_4, merchant_3])
    end
    it ".top_states" do
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

      expect(User.top_states).to eq([user_1.state, user_6.state, user_3.state])
    end

    it ".top_cities" do
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

      expect(User.top_cities).to eq([user_1.city, user_3.city, user_5.city])
    end
  end

  describe 'instance methods' do
    it '#status' do
      user = FactoryBot.create(:user)
      expect(user.status).to eq("Enabled")
      user.enabled = false
      expect(user.status).to eq("Disabled")
    end

    it '#merchant_pending_orders' do
      # Current_user
      user = FactoryBot.create(:merchant)

      # Another merchant
      user_2 = FactoryBot.create(:merchant)

      # Item for other merchant
      item_1 = FactoryBot.create(:item, user: user_2)

      # Item for current_user
      item_2 = FactoryBot.create(:item, user: user)

      # Order - pending -for other merchant - should not show up
      order_1 = FactoryBot.create(:pending, items: [item_1])

      # Order - pending -for current_user - should show up
      order_2 = FactoryBot.create(:pending)
      order_item = FactoryBot.create(:order_item, order: order_2, item: item_2)

      # Creates a second order to insure a list is populating to the page for the current_user.
      order_5 = FactoryBot.create(:pending)
      order_item_2 = FactoryBot.create(:order_item, order: order_5, item: item_2)

      # Order - cancelled -for current_user - should not show up
      order_3 = FactoryBot.create(:cancelled, items: [item_1, item_2])

      # Order - fulfilled -for current_user - should not show up
      order_4 = FactoryBot.create(:fulfilled, items: [item_1, item_2])

      expect(user.merchant_pending_orders).to eq([order_2, order_5])

    end
    it '.my_order_items(order)' do
      merchant = FactoryBot.create(:merchant)
      item_1 = FactoryBot.create(:item)
      item_2 = FactoryBot.create(:item)
      FactoryBot.create(:item)
      merchant.items << item_1

      order = FactoryBot.create(:order, items: [item_1, item_2])

      expect(merchant.my_order_items(order)).to eq(item_1.order_items)
    end
  end
end
