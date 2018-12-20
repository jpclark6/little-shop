require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    it {should validate_presence_of :status}
  end
  describe 'relationships' do
    it {should belong_to :user}
    it {should have_many :order_items}
  end

  describe 'instance method' do
    it '.total_quantity' do
      item_1 = FactoryBot.create(:item)
      item_2 = FactoryBot.create(:item)
      item_3 = FactoryBot.create(:item)

      order = FactoryBot.create(:pending, items: [item_1,item_2,item_3])

      item_1.order_items.first.update(quantity: 1)
      item_2.order_items.first.update(quantity: 2)
      item_3.order_items.first.update(quantity: 3)

      expect(order.total_quantity).to eq(6)
    end

    it '.total_price' do
      item_1 = FactoryBot.create(:item)
      item_2 = FactoryBot.create(:item)
      item_3 = FactoryBot.create(:item)

      order = FactoryBot.create(:pending, items: [item_1,item_2,item_3])

      item_1.order_items.first.update(quantity: 1, price: 5)
      item_2.order_items.first.update(quantity: 2, price: 12)
      item_3.order_items.first.update(quantity: 3, price: 8)

      expect(order.total_price).to eq(25)
    end
  end
end
