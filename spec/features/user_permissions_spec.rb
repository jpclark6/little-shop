require 'rails_helper'

describe 'as a visitor' do
  it 'should not be allowed to see admin, registered and merchant paths' do
    paths = [ profile_path,
              profile_edit_path,
              dashboard_path,
              dashboard_items_path,
              new_dashboard_item_path,
              dashboard_orders_path,
              dashboard_order_path(1),
              admin_merchant_path(1),
              admin_user_path(1),
              admin_order_path(1),
              admin_users_path ]

    paths.each do |path|
      visit path

      expect(page.status_code).to eq(404)
      expect(page).to have_content("The page you were looking for doesn't exist")
    end
  end
end
describe 'as a registered user' do
  it 'should not be allowed to see admin and merchant paths' do
    user_1 = FactoryBot.create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_1)

    paths = [ dashboard_path,
              dashboard_items_path,
              new_dashboard_item_path,
              dashboard_orders_path,
              dashboard_order_path(1),
              admin_merchant_path(1),
              admin_user_path(1),
              admin_order_path(1),
              admin_users_path ]

    paths.each do |path|
      visit path

      expect(page.status_code).to eq(404)
      expect(page).to have_content("The page you were looking for doesn't exist")
    end
  end
end
describe 'as a merchant' do
  it 'should not be allowed to see admin, profile and cart paths' do
    merchant = FactoryBot.create(:merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

    paths = [ profile_path,
              profile_edit_path,
              cart_path,
              admin_merchant_path(1),
              admin_user_path(1),
              admin_order_path(1),
              admin_users_path ]

    paths.each do |path|
      visit path

      expect(page.status_code).to eq(404)
      expect(page).to have_content("The page you were looking for doesn't exist")
    end
  end
end
describe 'as a admin' do
  it 'should not be allowed to see cart, registered and merchant paths' do
    admin = FactoryBot.create(:admin)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    paths = [ profile_path,
              profile_edit_path,
              dashboard_path,
              dashboard_items_path,
              new_dashboard_item_path,
              dashboard_orders_path,
              dashboard_order_path(1),
              cart_path]

    paths.each do |path|
      visit path

      expect(page.status_code).to eq(404)
      expect(page).to have_content("The page you were looking for doesn't exist")
    end
  end
end
