require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    it {should validate_presence_of :status}
  end
  describe 'relationships' do
    it {should belong_to :user}
    it {should have_many :order_items}
  end

  describe 'instance methods' do
    it 'should add cart contents on to an order' do
      item_1 = FactoryBot.create(:item)
      item_2 = FactoryBot.create(:item)
      item_3 = FactoryBot.create(:item)
      cart = Cart.new({})
      cart.add_item(item_1.id.to_s)
      cart.add_item(item_2.id.to_s)
      cart.add_item(item_2.id.to_s)
      cart.add_item(item_3.id.to_s)
      user = FactoryBot.create(:user)
      order = Order.create(user: user, status: 'pending')
      order.add_cart(cart)
      expect(order.items).to eq([item_1, item_2, item_3])
    end

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

      item_1.order_items.first.update(quantity: 1, price: 1)
      item_2.order_items.first.update(quantity: 2, price: 2)
      item_3.order_items.first.update(quantity: 3, price: 3)

      expect(order.total_price).to eq(14)
    end

    it '.cancel_order' do
      item_1 = FactoryBot.create(:item)
      item_2 = FactoryBot.create(:item)
      item_3 = FactoryBot.create(:item)

      item_1_pre_inv = item_1.instock_qty
      item_2_pre_inv = item_2.instock_qty
      item_3_pre_inv = item_3.instock_qty

      order_1 = FactoryBot.create(:pending, items: [item_1,item_2,item_3])

      item_1.order_items.first.update(price: 2, quantity: 3, fulfilled: false)
      item_2.order_items.first.update(price: 3, quantity: 1, fulfilled: true)
      item_3.order_items.first.update(price: 4, quantity: 5, fulfilled: false)

      order_1.cancel_order

      expect(order_1.status).to eq('cancelled')

      expect(order_1.order_items[0].fulfilled).to eq(false)
      expect(order_1.order_items[1].fulfilled).to eq(false)
      expect(order_1.order_items[2].fulfilled).to eq(false)

      expect(item_1.instock_qty).to eq(item_1_pre_inv)
      expect(item_2.instock_qty).to eq(item_2_pre_inv + 1)
      expect(item_3.instock_qty).to eq(item_3_pre_inv)
    end

    it ".fulfill_if_complete" do
      merchant = FactoryBot.create(:merchant)
      item_1 = FactoryBot.create(:item, instock_qty: 17)
      item_2 = FactoryBot.create(:item, instock_qty: 3)
      merchant.items += [item_1, item_2]
      order = FactoryBot.create(:order)

      order_item_1 = FactoryBot.create(:order_item, item: item_1, order: order, quantity: 5, fulfilled: true)
      order_item_2 = FactoryBot.create(:order_item, item: item_2, order: order, quantity: 2)

      order.reload.fulfill_if_complete
      expect(order.reload.status).to eq("pending")
      order_item_2.update(fulfilled: true)
      expect(order.reload.status).to eq("pending")
      order.fulfill_if_complete

      expect(order.reload.status).to eq("fulfilled")

    end
  end
  it '.biggest_orders' do
    order_1 = FactoryBot.create(:order)
    order_item_1 = FactoryBot.create(:order_item, order: order_1, quantity: 5)

    order_2 = FactoryBot.create(:order)
    order_item_2 = FactoryBot.create(:order_item, order: order_2, quantity: 15)

    order_3 = FactoryBot.create(:order)
    order_item_3 = FactoryBot.create(:order_item, order: order_3, quantity: 7)

    order_4 = FactoryBot.create(:order)
    order_item_4 = FactoryBot.create(:order_item, order: order_4, quantity: 2)

    expect(Order.biggest_orders).to eq([order_2, order_3, order_1])
  end
end
