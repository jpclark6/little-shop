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
      expect(item_1.avg_fulfillment_time.sub(/\.\d*$/, '')).to eq("1 day 12:12:00")
    end
  end
  describe 'class methods' do
    before(:each) do
      @item_1 = FactoryBot.create(:item)
      @item_2 = FactoryBot.create(:item)
      @item_3 = FactoryBot.create(:item)
      @item_4 = FactoryBot.create(:item)
      @item_5 = FactoryBot.create(:item)
      @item_6 = FactoryBot.create(:item)

      FactoryBot.create_list(:order_item, 3, item: @item_6, quantity: 10, fulfilled: true)
      FactoryBot.create_list(:order_item, 2, item: @item_4, quantity: 12, fulfilled: true)
      FactoryBot.create_list(:order_item, 1, item: @item_2, quantity: 13, fulfilled: true)
      FactoryBot.create_list(:order_item, 2, item: @item_1, quantity: 6, fulfilled: true)
      FactoryBot.create_list(:order_item, 1, item: @item_3, quantity: 1, fulfilled: true)
    end
    it '.top_5' do
      expected = [@item_6, @item_4, @item_2, @item_1, @item_3]
      result = Item.top_5
      expect(result[0].id).to eq(expected[0].id)
      expect(result[1].id).to eq(expected[1].id)
      expect(result[2].id).to eq(expected[2].id)
      expect(result[3].id).to eq(expected[3].id)
      expect(result[4].id).to eq(expected[4].id)

      expect(result[0].units_sold).to eq(30)

      expect(result.size).to eq(5)
    end
    it '.bottom_5' do
      expected = [@item_5, @item_3, @item_1, @item_2, @item_4]
      result = Item.bottom_5

      expect(result.length).to eq(5)
      # when I called .size instead of .length it tried to integrate that into the ActiveRecord query

      expect(result[0].id).to eq(expected[0].id)
      expect(result[1].id).to eq(expected[1].id)
      expect(result[2].id).to eq(expected[2].id)
      expect(result[3].id).to eq(expected[3].id)
      expect(result[4].id).to eq(expected[4].id)

      expect(result[0].units_sold).to eq(0)
    end

  end
end
