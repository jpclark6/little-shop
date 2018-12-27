require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'validations' do
  end
  describe 'relationships' do
    it {should belong_to :item}
    it {should belong_to :order}
  end
  describe 'instance methods' do
    it ".subtotal" do
      order_item_1 = FactoryBot.create(:order_item, price: 2, quantity: 3)
      expect(order_item_1.subtotal).to eq(6)
    end

    it '.fulfillable?' do
      order_item_1 = FactoryBot.create(:order_item, fulfilled: true)
      order_item_1 = FactoryBot.create(:order_item, fulfilled: false)

      expect(order_item_1.fulfillable?).to eq(false)
      expect(order_item_2.fulfillable?).to eq(true)
    end
  end

  describe 'before_validations' do
    it ".ensures_price is equal to item price" do
      user = FactoryBot.create(:user)
      item_1 = FactoryBot.create(:item, price: 3.50)
      order_1 = Order.create!(user: user, items: [item_1])

      expect(order_1.order_items[0].price).to eq(item_1.price)
    end
  end
end
