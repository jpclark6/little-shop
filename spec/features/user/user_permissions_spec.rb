require 'rails_helper'

describe 'user_permissions' do
  def check_paths(paths)
    paths.each do |path|
      visit path
      expect(current_path).to eq(path)
      expect(page.status_code).to eq(404)
      expect(page).to have_content("The page you were looking for doesn't exist")
    end
  end

  before(:each) do

    @paths_that_should_require_merchant = [
        dashboard_path,
        dashboard_items_path,
        new_dashboard_item_path,
        dashboard_orders_path,
        dashboard_order_path(1),
      ]
    @paths_that_should_require_admin = [
        admin_merchant_path(1),
        admin_user_path(1),
        admin_order_path(1),
        admin_users_path
      ]

    @paths_that_should_require_regular_user = [
        profile_path,
        profile_edit_path,
      ]

    @paths_that_admins_and_merchants_cannot_see = [
        cart_path
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
