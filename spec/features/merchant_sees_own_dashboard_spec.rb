require 'rails_helper'

describe 'as a Merchant' do
  it 'displays the merchants own profile data on the dashboard, but cannot edit' do
    user = FactoryBot.create(:merchant)

    visit "/dashboard/#{user.id}"

    expect(page).to have_content(user.name)
    expect(page).to have_content(user.email)
    expect(page).to_not have_content(user.password)
    expect(page).to have_content(user.address)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip_code)
    expect(page).to have_no_link('Edit Profile')
  end

end

# I see my profile data, but cannot edit it --- TEST FOR THIS?????
