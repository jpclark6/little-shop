require 'rails_helper'

describe 'user_permissions' do
  def check_paths(paths)
    paths.each do |path|
      page.driver.submit path[0], path[1], {} rescue binding.pry
      expect(current_path).to eq(path[1])
      expect(page.status_code).to eq(404)
      expect(page).to have_content("The page you were looking for doesn't exist")
    end
  end

  before(:each) do

    @paths_that_should_require_merchant = [
      [:get, dashboard_path],
      [:get, dashboard_items_path],
      [:post, dashboard_items_path],
      [:get, new_dashboard_item_path],
      [:put, dashboard_item_path(1)],
      [:patch, dashboard_item_path(1)],
      [:delete, dashboard_item_path(1)],
      [:get, dashboard_orders_path],
      [:get, dashboard_order_path(1)],
      [:patch, dashboard_item_toggle_path(1)],
      [:patch, dashboard_order_item_fulfill_path(1)]
    ]
    @paths_that_should_require_admin = [
      [:get, admin_merchant_items_path(1)],
      [:post, admin_merchant_items_path(1)],
      [:get, new_admin_merchant_item_path(1)],
      [:get, edit_admin_item_path(1)],
      [:patch, admin_item_path(1)],
      [:put, admin_item_path(1)],
      [:delete, admin_item_path(1)],
      [:get, admin_users_path],
      [:get, edit_admin_user_path(1)],
      [:get, admin_user_path(1)],
      [:patch, admin_user_path(1)],
      [:put, admin_user_path(1)],
      [:get, admin_order_path(1)],
      [:delete, admin_order_path(1)],
      [:patch, admin_item_toggle_path(1)],
      [:patch, admin_toggle_user_path(1)],
      [:patch, admin_user_upgrade_path(1)],
      [:patch, admin_merchant_downgrade_path(1)],
      [:get, admin_merchant_path(1)],
      [:patch, admin_order_item_fulfill_path(1)]
    ]

    @paths_that_should_require_regular_user = [
      [:get, profile_path],
      [:get, profile_orders_path],
      [:post, profile_orders_path],
      [:get, profile_order_path(1)],
      [:delete, profile_order_path(1)],
      [:get, profile_edit_path],
      [:patch, profile_update_path(1)]
    ]

    @paths_that_admins_and_merchants_cannot_see = [
      [:post, carts_path],
      [:get, cart_path],
      [:patch, cart_path],
      [:delete, cart_path],
    ]
  end

  describe 'as a visitor' do
    it 'should not be allowed to see admin, registered and merchant paths' do
      paths = @paths_that_should_require_merchant +
              @paths_that_should_require_regular_user +
              @paths_that_should_require_admin
      check_paths(paths)
    end
  end
  describe 'as a registered user' do
    it 'should not be allowed to see admin and merchant paths' do
      user_1 = FactoryBot.create(:user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_1)

      paths = @paths_that_should_require_merchant +
              @paths_that_should_require_admin

      check_paths(paths)
    end
  end
  describe 'as a merchant' do
    it 'should not be allowed to see admin, profile and cart paths' do
      merchant = FactoryBot.create(:merchant)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      paths = @paths_that_should_require_regular_user +
              @paths_that_should_require_admin +
              @paths_that_admins_and_merchants_cannot_see

      check_paths(paths)
    end
  end
  describe 'as a admin' do
    it 'should not be allowed to see cart, registered and merchant paths' do
      admin = FactoryBot.create(:admin)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      paths = @paths_that_should_require_regular_user +
              @paths_that_should_require_merchant +
              @paths_that_admins_and_merchants_cannot_see

      check_paths(paths)
    end
  end
end
