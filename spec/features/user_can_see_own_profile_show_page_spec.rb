require "rails_helper"

describe 'registered user visits their own profile page' do
  it 'shows all profile data except password' do
    user = FactoryBot.create(:user)
    user_2 = FactoryBot.create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit profile_path(user)

    expect(page).to have_content(user.name)
    expect(page).to have_content(user.address)
    expect(page).to have_content(user.email)
    expect(page).to_not have_content(user.password)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip_code)

    expect(page).to_not have_content(user_2.name)
    expect(page).to_not have_content(user_2.email)
  end

  it 'can see a link to edit my profile data' do
    user = FactoryBot.create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit profile_path(user)

    click_on 'Edit Profile'

    expect(current_path).to eq(edit_user_path(user))
  end


end
