require "rails_helper"
describe 'as an admin' do
  it 'I see a users profile with all the information they see' do
    admin = FactoryBot.create(:admin)
    user = FactoryBot.create(:user)
    user_2 = FactoryBot.create(:user)
    item_1 = FactoryBot.create(:item)
    item_2 = FactoryBot.create(:item)
    item_3 = FactoryBot.create(:item)

    order_1 = Order.create!(user: user)
    order_2 = Order.create!(user: user)

    order_1.items += [item_1, item_2]
    order_2.items << item_3

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit admin_user_path(user)

    expect(page).to have_content(user.name)
    expect(page).to have_content(user.address)
    expect(page).to have_content(user.email)
    expect(page).to_not have_content(user.password)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip_code)

    expect(page).to_not have_content(user_2.name)
    expect(page).to_not have_content(user_2.email)

    expect(page).to have_link('Edit Profile')

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
