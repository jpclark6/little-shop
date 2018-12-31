# As an admin user
# When I visit a user's profile page ("/admin/users/5")
# I see a link to "upgrade" the user's account to become a merchant
# When I click on that link
# I am redirected to ("/admin/merchants/5") because the user is now a merchant
# And I see a flash message indicating the user has been upgraded
# The next time this user logs in they are now a merchant
# Only admins can see the "upgrade" link
# Only admins can reach any route necessary to upgrade the user to merchant status
require "rails_helper"

describe 'admin changes a user role' do
  it 'from user to merchant' do
    user = FactoryBot.create(:user)
    admin = FactoryBot.create(:admin)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit admin_user_path(user)
    click_on("Upgrade To Merchant")

    expect(current_path).to eq(admin_merchant_path(user))

    expect(page).to have_content("User #{user.id} with name '#{user.name}' is now a merchant.")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user.reload)

    visit "/"

    within "nav" do
      expect(page).to have_content("Dashboard")
    end
  end
  it 'merchant to user' do
    merchant = FactoryBot.create(:merchant)
    admin = FactoryBot.create(:admin)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit admin_merchant_path(merchant)
    click_on("Downgrade From Merchant")

    expect(current_path).to eq(admin_user_path(merchant))

    expect(page).to have_content("User #{merchant.id} with name '#{merchant.name}' is no longer a merchant.")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant.reload)

    visit "/"

    within "nav" do
      expect(page).to have_content("Profile")
    end
  end

end
