require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :instock_qty}
    it {should validate_presence_of :price}
    it {should validate_presence_of :description}
  end
  describe 'relationships' do
    it {should belong_to :user}
    it {should have_many :order_items}
    it {should have_many(:orders).through(:order_items)}
  end
  describe 'instance methods' do
    it '.never_ordered?' do
      merchant = FactoryBot.create(:merchant)
      item_1 = FactoryBot.create(:item)
      item_2 = FactoryBot.create(:item)
      item_2.orders << FactoryBot.create(:fulfilled)

      expect(item_1.never_ordered?).to eq(true)
      expect(item_2.never_ordered?).to eq(false)
    end
    it '.avg_fulfillment_time' do
      item_1 = FactoryBot.create(:item)
      user_1 = FactoryBot.create(:user)
      order_1 = item_1.orders.create(user: user_1)
      order_2 = item_1.orders.create(user: user_1)
      unfulfilled_order = item_1.orders.create(user: user_1)

      order_1.order_items.first.update(fulfilled: true, created_at: 0.4.hours.ago)
      order_2.order_items.first.update(fulfilled: true, created_at: 3.days.ago)
      unfulfilled_order.order_items.first.update(fulfilled: false, created_at: 21.days.ago)
      expect(item_1.avg_fulfillment_time[0..-8]).to eq("1 day 12:12:00")
    end
  end
end
