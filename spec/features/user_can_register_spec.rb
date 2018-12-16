require 'rails_helper'

describe 'as a visitor' do
  describe 'when I click Register I can register' do
    it "can navigate to registration page" do
      visit root_path

      click_on "Register"

      expect(current_path).to eq("/register")
    end
    it "can fill in form" do
      visit register_path

      fill_in :user_name, with: "John Doe"
      fill_in :user_address, with: "433 Larimer"
      fill_in :user_city, with: "Denver"
      fill_in :user_state, with: "CO"
      fill_in :user_zip_code, with: 80026
      fill_in :user_email, with: "john@gmail.com"
      fill_in :user_password, with: "john"
      fill_in :user_password_confirmation, with: "john"
      click_on "Create User"

      expect(current_path).to eq("/profile")
      within ".alert" do
        expect(page).to have_content("You are registered and logged in")
      end
      expect(User.last.name).to eq("John Doe")
      expect(User.last.city).to eq("Denver")
      expect(User.last.email).to eq("john@gmail.com")
    end
  end
end
