require 'rails_helper'

describe 'As a Merchant' do
  it 'displays the merchants own profile data on the dashboard, but cannot edit' do
    user = FactoryBot.create(:merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/dashboard"

    expect(page).to have_content(user.name)
    expect(page).to have_content(user.email)
    expect(page).to_not have_content(user.password)
    expect(page).to have_content(user.address)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip_code)
    expect(page).to have_no_link('Edit Profile')
  end

  it 'When I visit my dashboard, I see a link to view my own items. When I click the link it navigates me to /dashboard/items' do
    user = FactoryBot.create(:merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/dashboard"

    click_on 'View Items'

    expect(current_path).to eq('/dashboard/items')

    #did not test for expecting a user_cannot see this.
  end

# Merchant's Items index page
#
# As a merchant
# When I visit my dashboard
# I see a link to view my own items
# When I click that link
# My URI route should be "/dashboard/items"

end
