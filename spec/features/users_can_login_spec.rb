require 'rails_helper'

describe 'as a regular user' do
  it 'I enter valid info for email and password and am redirected to /profile' do
    user = FactoryBot.create(:user)

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on 'Log In'

    expect(current_path).to eq(profile_path(user))
    expect(page).to have_content("Welcome, #{user.name}")
  end
end
