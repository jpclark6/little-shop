require "rails_helper"
describe 'user index page' do
  context 'as an admin' do

    it "disables a user when I click disable" do
      user = FactoryBot.create(:user)
      admin = FactoryBot.create(:admin)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit admin_users_path
      within "#user-#{user.id}" do
        click_on "Disable"
      end

      expect(current_path).to eq(admin_users_path)

      expect(page).to have_content("#{user.name} (id:#{user.id}) is now disabled.")

      visit admin_users_path

      within "#user-#{user.id}" do
        save_and_open_page
        expect(page).to have_content("Status: Disabled")

      end

    end
  end
end


# As an admin user
# When I visit the user index page
# And I click on a "disable" button for an enabled user
# I am returned to the admin's user index page
# And I see a flash message that the user's account is now disabled
# And I see that the user's account is now disabled
# This user cannot log in
