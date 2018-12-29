require "rails_helper"

describe 'as an admin' do
  describe 'when I visit a user profile' do
    it 'can edit their info' do
      user = FactoryBot.create(:user)
      admin = FactoryBot.create(:admin)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit admin_user_path(user)

      click_link "Edit Profile"

      expect(current_path).to eq(edit_admin_user_path(user))

      fill_in :user_name, with: "John Doe"
      fill_in :user_address, with: "433 Larimer"
      fill_in :user_city, with: "Denver"
      fill_in :user_state, with: "CO"
      fill_in :user_zip_code, with: 80026
      fill_in :user_email, with: "john@gmail.com"
      fill_in :user_password, with: "15"

      click_on "Update User"

      expect(current_path).to eq(admin_user_path(user))
      expect(page).to have_content("Your data is updated")
      expect(page).to have_content("John Doe")
      expect(page).to have_content("433 Larimer")
      expect(page).to have_content("Denver")
      expect(page).to have_content("CO")
      expect(page).to have_content(80026)
      expect(page).to have_content("john@gmail.com")
    end
    it 'It shows flash when same email is entered' do
      user = FactoryBot.create(:user)
      user_2 = FactoryBot.create(:user, email: "andrew@gmail.com")
      admin = FactoryBot.create(:admin)

      visit login_path

      fill_in :email, with: admin.email
      fill_in :password, with: admin.password
      click_on 'Log In'

      visit admin_user_path(user)

      click_on "Edit Profile"

      fill_in :user_email, with: "andrew@gmail.com"

      click_on "Update User"

      expect(page).to have_content("Your email has already been taken")
    end
  end
end
