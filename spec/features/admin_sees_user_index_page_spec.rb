require "rails_helper"
describe 'user index page' do
  context 'as an admin' do

    it "shows all registered users" do
      user_1 = FactoryBot.create(:user)
      user_2 = FactoryBot.create(:user, enabled: false)
      merchant = FactoryBot.create(:merchant)
      admin = FactoryBot.create(:admin)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit root_path
      within ".nav-link-container" do
        click_on 'Users'
      end

      expect(current_path).to eq("/admin/users")
      within "#user-#{user_1.id}" do
        expect(page).to have_content(user_1.name)
        expect(page).to have_content("Registered at #{user_1.created_at.to_date}")
        expect(page).to have_button("Disable")
      end
      within "#user-#{user_2.id}" do
        expect(page).to have_content(user_2.name)
        expect(page).to have_content("Registered at #{user_2.created_at.to_date}")
        expect(page).to have_button("Enable")
      end

      expect(page).to_not have_css("#user-#{merchant.id}")
      expect(page).to_not have_css("#user-#{admin.id}")
    end
    it "links me to the user's show page when I click on the name" do
      user_1 = FactoryBot.create(:user)
      admin = FactoryBot.create(:admin)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
      visit admin_users_path
      within "#user-#{user_1.id}" do
        click_on user_1.name
      end
      expect(current_path).to eq(admin_user_path(user_1))
    end
  end
end
