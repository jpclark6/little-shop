require "rails_helper"
describe 'when I want it work' do
  xit 'works' do
    user = FactoryBot.build(:user)
    expect(user.email).to eq("Lisa1@gmail.com")
    expect(user.name).to eq("Lisa")
    user = FactoryBot.build(:user, name: "joe")
    expect(user.name).to eq("joe")

  end

end
