require "rails_helper"

describe 'as a registerd user' do
  describe 'when I am in my profile page' do
    it 'I can edit profile info ' do
      user = FactoryBot.create(:user)
      visit login_path

      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_on 'Log In'

      visit profile_path

      click_on "Edit Profile"

      expect(current_path).to eq("/profile/edit")

      expect(find_field(:user_name).value).to eq(user.name)
      expect(find_field(:user_address).value).to eq(user.address)
      expect(find_field(:user_city).value).to eq(user.city)
      expect(find_field(:user_state).value).to eq(user.state)
      expect(find_field(:user_zip_code).value.to_i).to eq(user.zip_code)
      expect(find_field(:user_email).value).to eq(user.email)


      fill_in :user_name, with: "John Doe"
      fill_in :user_address, with: "433 Larimer"
      fill_in :user_city, with: "Denver"
      fill_in :user_state, with: "CO"
      fill_in :user_zip_code, with: 80026
      fill_in :user_email, with: "john@gmail.com"
      fill_in :user_password, with: "15"
      fill_in :user_password_confirmation, with: "15"

      click_on "Update User"

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("Your data is updated")
      expect(page).to have_content("John Doe")
      expect(page).to have_content("433 Larimer")
      expect(page).to have_content("Denver")
      expect(page).to have_content("CO")
      expect(page).to have_content(80026)
      expect(page).to have_content("john@gmail.com")
    end
    it 'It shows flash when non-unique email is entered, or when data is blank' do
      user_1 = FactoryBot.create(:user, email: "andrew@gmail.com")
      user_2 = FactoryBot.create(:user)

      visit login_path

      fill_in :email, with: user_2.email
      fill_in :password, with: user_2.password
      click_on 'Log In'

      visit profile_path

      click_on "Edit Profile"

      fill_in :user_address, with: ""
      fill_in :user_email, with: "andrew@gmail.com"

      click_on "Update User"

      expect(current_path).to eq(profile_update_path)
      expect(page).to have_content("Your address can't be blank")
      expect(page).to have_content("Your email has already been taken")
    end
  end
end
