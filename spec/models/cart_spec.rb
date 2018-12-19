require 'rails_helper'

RSpec.describe Cart do
  subject { Cart.new({'1' => 2, '2' => 3}) }

  describe "#total_count" do
    it "can calculate the total number of items it holds" do

      expect(subject.total_count).to eq(5)
    end
  end

  describe "#add_item" do
    it "adds an item to its contents" do
      cart = Cart.new({
        "1" => 2,
        "2" => 3
        })
        cart.add_item(1)
        cart.add_item(2)

        expect(cart.contents).to eq({"1" => 3, "2" => 4})
    end
  end
  describe "#count_of" do
    it "can count" do

      cart = Cart.new({})

      expect(cart.count_of(5)).to eq(0)
    end
  end
  describe "#current_items" do
    it "can find all items" do
      item_1 = FactoryBot.create(:item)
      item_2 = FactoryBot.create(:item)
      item_3 = FactoryBot.create(:item)
      cart = Cart.new({})
      cart.add_item(item_1.id.to_s)
      cart.add_item(item_2.id.to_s)
      cart.add_item(item_3.id.to_s)
      expect(cart.current_items).to eq([item_1, item_2, item_3])
    end
  end
end
