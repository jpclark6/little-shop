require "rails_helper"
describe 'As a registered user' do
  it 'my profile order index displays correctly' do

    item_1 = FactoryBot.create(:item)
    item_2 = FactoryBot.create(:item)
    item_3 = FactoryBot.create(:item)
    user = FactoryBot.create(:user)

    order_1 = FactoryBot.create(:order, user: user, items: [item_1, item_2] )
    order_2 = FactoryBot.create(:order, user: user, items: [item_3], status: "fulfilled")
    order_2 = FactoryBot.create(:order, user: user, items: [item_3], status: "cancelled")

    visit profile_orders_path
    save_and_open_page

    within(".order-#{order_1.id}") do
      expect(page).to have_link(order_1.id)
      expect(page).to have_content(order_1.created_at)
      expect(page).to have_content(order_1.updated_at)
      expect(page).to have_content(order_1.status)
      expect(page).to have_content(order_1.total_quantity)
      expect(page).to have_content(order_1.total_price)
    end

    within(".order-#{order_2.id}") do
      expect(page).to have_link(order_2.id)
      expect(page).to have_content(order_2.created_at)
      expect(page).to have_content(order_2.updated_at)
      expect(page).to have_content(order_2.status)
      expect(page).to have_content(order_2.total_quantity)
      expect(page).to have_content(order_2.total_price)
    end
  end
end
