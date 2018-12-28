require "rails_helper"
describe 'As a registered user' do
  it 'my profile order index displays correctly' do

    item_1 = FactoryBot.create(:item)
    item_2 = FactoryBot.create(:item)
    item_3 = FactoryBot.create(:item)
    user = FactoryBot.create(:user)

    order_1 = FactoryBot.create(:order, user: user, items: [item_1, item_2] )
    order_2 = FactoryBot.create(:order, user: user, items: [item_3], status: "fulfilled")
    order_3 = FactoryBot.create(:order, user: user, items: [item_3], status: "cancelled")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit profile_orders_path
    save_and_open_page

    orders = [order_1, order_2, order_3]

    orders.each do |order|
      within(".order-#{order.id}") do
        expect(page).to have_link(order.id)
        expect(page).to have_content(order.created_at)
        expect(page).to have_content(order.updated_at)
        expect(page).to have_content(order.status)
        expect(page).to have_content(order.total_quantity)
        expect(page).to have_content(order.total_price)
      end
    end

  end
end
