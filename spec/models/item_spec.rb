require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :instock_qty}
    it {should validate_presence_of :price}
    it {should validate_presence_of :image}
    it {should validate_presence_of :description}
  end
  describe 'relationships' do
    it {should have_many :users}
    it {should have_many :order_items}
  end
end
