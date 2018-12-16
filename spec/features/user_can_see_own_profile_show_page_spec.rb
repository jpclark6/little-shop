require "rails_helper"

describe 'user visits their own profile page' do
  it 'shows all profile data except password' do
    name = 'Jill'
    address = '122 Broadway'
    email = '123@gmail.com'
    password = '337*7!'
    city = 'Denver'
    state = 'CO'
    zip_code = 80015

    user = FactoryBot.create(:user, name: name, address: address, email: email, password: password, city: city, state: state, zip_code: zip_code )

    visit profile_path(user)

    expect(page).to have_content(user.name)
    expect(page).to have_content(user.address)
    expect(page).to have_content(user.email)
    expect(page).to_not have_content(user.password)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip_code)
  end

  it 'can see a link to edit my profile data' do
    user = FactoryBot.create(:user)

    visit profile_path(user)

    click_on 'Edit Profile'

    expect(current_path).to eq(edit_user_path(user))
  end


end
