require 'rails_helper'

describe 'as a visitor or registered user' do
  before(:each) do
    @item_1 = FactoryBot.create(:item)
    @item_2 = FactoryBot.create(:item)
    @item_3 = FactoryBot.create(:item)

    visit item_path(@item_1)
    click_button "Add Item"
    visit item_path(@item_2)
    click_button "Add Item"
    visit item_path(@item_3)
    click_button "Add Item"
  end

  describe 'when I have items in my cart' do
    it 'should see all items in cart' do
      visit cart_path

      expect(page).to have_content(@item_1.name)
      expect(page).to have_css("img[src*='#{@item_1.image}']")
      expect(page).to have_content(@item_2.name)
      expect(page).to have_css("img[src*='#{@item_2.image}']")
      expect(page).to have_content(@item_3.name)
      expect(page).to have_css("img[src*='#{@item_3.image}']")
    end
  end
end
