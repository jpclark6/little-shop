require 'rails_helper'

describe 'as a visitor' do
  it 'should not be allowed to see admin, registered and merchant paths' do
    paths = [ profile_path,
              profile_edit_path,
              dashboard_path,
              dashboard_items_path,
              dashboard_items_new_path,
              dashboard_orders_path,
              dashboard_order_path(1),
              admin_merchant_path(1),
              admin_user_path(1),
              admin_users_path ]

    paths.each do |path|
      visit path

      expect(page.status_code).to eq(404)
      expect(page).to have_content("The page you were looking for doesn't exist")
    end
  end
end
