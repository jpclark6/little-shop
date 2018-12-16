require "rails_helper"

describe 'user visits their own profile page' do
  it 'shows all profile data except password' do
  User.create(name: 'Jill', address: '378 S Broadway', city: 'Denver', state: 'CO', zip_code: 80015 )

    visit user_path(user)


  end

end
