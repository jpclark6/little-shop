require 'rails_helper'

describe 'as a regular user' do
  it 'I enter valid info for email and password and am redirected to /profile' do
    user = FactoryBot.create(:user)

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on 'Log In'

    expect(current_path).to eq(profile_path)
    expect(page).to have_content("Welcome, #{user.name}")
  end
end

describe 'as a merchant user' do
  it 'I enter valid info for email and password and am redirected to my merchant dashboard page' do
    merchant = FactoryBot.create(:merchant)

    visit login_path

    fill_in :email, with: merchant.email
    fill_in :password, with: merchant.password
    click_on 'Log In'

    expect(current_path).to eq("/dashboard")
    expect(page).to have_content("Welcome, #{merchant.name}")
  end
end

describe 'as an admin user' do
  it 'I enter valid info for email and password and am redirected to the home page' do
    admin = FactoryBot.create(:admin)

    visit login_path

    fill_in :email, with: admin.email
    fill_in :password, with: admin.password
    click_on 'Log In'

    expect(current_path).to eq(root_path)
    expect(page).to have_content("Welcome, #{admin.name}")
  end
end

describe 'as any user' do
  it 'if I enter invalid login credentials then I am redirected to the login page' do
    user = FactoryBot.create(:user)

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: "notapassword"
    click_on 'Log In'

    expect(current_path).to eq(login_path)
    expect(page).to have_content("Invalid credentials.")
  end
end

describe 'as a regular user' do
  it 'if I am already logged in I am redirected to /profile' do
    user = FactoryBot.create(:user)

    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on 'Log In'

    visit login_path

    expect(current_path).to eq(profile_path)
    expect(page).to have_content("You are already logged in")
  end
end

describe 'as a merchant user' do
  it 'if I am already logged in I am redirected to my merchant dashboard page' do
    merchant = FactoryBot.create(:merchant)

    visit login_path

    fill_in :email, with: merchant.email
    fill_in :password, with: merchant.password
    click_on 'Log In'

    visit login_path

    expect(current_path).to eq("/dashboard")
    expect(page).to have_content("You are already logged in")
  end
end

describe 'as an admin user' do
  it 'if I am already logged in I am redirected to the home page' do
    admin = FactoryBot.create(:admin)

    visit login_path

    fill_in :email, with: admin.email
    fill_in :password, with: admin.password
    click_on 'Log In'

    visit login_path

    expect(current_path).to eq(root_path)
    expect(page).to have_content("You are already logged in")
  end
end
