require 'rails_helper'

describe 'as a registered user' do
  it 'can log out' do
    user = FactoryBot.create(:user)

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on 'Log In'
    click_on 'Log Out'
  end
end
