require "rails_helper"
describe 'user index page' do
  context 'as an admin' do

    it "shows all registered users" do
      user_1 = FactoryBot.create(:user)
      user_2 = FactoryBot.create(:user)
      user_3 = FactoryBot.create(:user, enabled: false)

      merchant_1 = FactoryBot.create(:merchant)
      admin = FactoryBot.create(:admin)

      allow_any_instance_of(ApplicationCotroller).to receive(:current_user).and_return(admin)

      visit root_path
      within ".nav-link-container" do
        click_on 'Users'
      end

      expect(current_path).to eq("/admin/users")
      # expect(page).to
    end
  end
end


# As an admin user
# When I click on the "Users" link in the nav
# Then my current URI route is "/admin/users"
# And I see all users in the system who are not merchants nor admins
# Each user's name is a link to a show page for that user ("/admin/users/5")
# Next to each user's name is the date they registered
# I see a "disable" button next to any users who are not yet disabled
# I see an "enable" button next to any users whose accounts are disabled %>
