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
      merchant = FactoryBot.create(:merchant)
      item_1 = FactoryBot.create(:item, instock_qty: 1)
      item_2 = FactoryBot.create(:item, instock_qty: 2)
      item_3 = FactoryBot.create(:item, instock_qty: 2)
      merchant.items += [item_1, item_2, item_3]
      order = FactoryBot.create(:order)

      order_item_1 = FactoryBot.create(:order_item, item: item_1, order: order, quantity: 2)
      order_item_2 = FactoryBot.create(:order_item, item: item_2, order: order, quantity: 2)
      order_item_3 = FactoryBot.create(:order_item, item: item_2, order: order, quantity: 2, fulfilled: true)

      expect(order_item_1.fulfillable?).to eq(false)
      expect(order_item_2.fulfillable?).to eq(true)
      expect(order_item_3.fulfillable?).to eq(false)
    end

    # it '.fulfill_order_item' do
    #   merchant = FactoryBot.create(:merchant)
    #   item_1 = FactoryBot.create(:item, instock_qty: 1)
    #   item_2 = FactoryBot.create(:item, instock_qty: 2)
    #   merchant.items += [item_1, item_2]
    #   order = FactoryBot.create(:order)
    #
    #   order_item_1 = FactoryBot.create(:order_item, item: item_1, order: order, quantity: 2)
    #   order_item_2 = FactoryBot.create(:order_item, item: item_2, order: order, quantity: 2)
    #
    #   order_item_1.fulfill_order_item
    #
    #   expect(item_1.instock_qty).to eq(0)
    #
    #   order_item_2.fulfill_order_item
    #   expect(item_2.instock_qty).to eq(1)
    #   order_item_2.fulfill_order_item
    #   expect(item_2.instock_qty).to eq(0)
    # end
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
