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


      within "#user-#{user.id}" do
        expect(page).to have_content("Status: Disabled")
      end
    end

    xit 'should make sure disabled users cant log in' do

    end

    it "enables a user when I click enable" do
      user = FactoryBot.create(:user, :disabled)
      admin = FactoryBot.create(:admin)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit admin_users_path
      within "#user-#{user.id}" do
        click_on "Enable"
      end

      expect(current_path).to eq(admin_users_path)

      expect(page).to have_content("#{user.name} (id:#{user.id}) is now enabled.")


      within "#user-#{user.id}" do
        expect(page).to have_content("Status: Enabled")
      end
    end

    it "disables a merchant when I click disable" do
      merchant = FactoryBot.create(:merchant)
      admin = FactoryBot.create(:admin)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit merchants_path
      within "#merchant-#{merchant.id}" do
        click_on "Disable"
      end

      expect(current_path).to eq(merchants_path)

      expect(page).to have_content("#{merchant.name} (id:#{merchant.id}) is now disabled.")

      within "#merchant-#{merchant.id}" do
        expect(page).to have_content("Status: Disabled")
      end
    end

    it "enables a merchant when I click enable" do
      merchant = FactoryBot.create(:merchant, :disabled)
      admin = FactoryBot.create(:admin)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit merchants_path
      within "#merchant-#{merchant.id}" do
        click_on "Enable"
      end

      expect(current_path).to eq(merchants_path)

      expect(page).to have_content("#{merchant.name} (id:#{merchant.id}) is now enabled.")

      within "#merchant-#{merchant.id}" do
        expect(page).to have_content("Status: Enabled")
      end
    end

  end
end
