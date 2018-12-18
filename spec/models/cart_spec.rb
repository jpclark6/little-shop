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
end
