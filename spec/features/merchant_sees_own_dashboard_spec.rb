require 'rails_helper'

describe 'as a Merchant' do
  it 'displays the merchants own profile data on the dashboard, but cannot edit' do
    user = FactoryBot.create(:user, role: 1)

    visit "/dashboard/(#{user.id})"

    expect(page).to have_content(user.name)
    expect(page).to have_content(user.email)
    expect(page).to_not have_content(user.password)
    expect(page).to have_content(user.address)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip_code)
  end

end

# DO WE WANT PASSWORD TO DISPLAY

# Merchant Dashboard Show Page
# As a merchant user
# When I visit my dashboard ("/dashboard")
# I see my profile data, but cannot edit it --- TEST FOR THIS?????
