#This is testing a bug fix

require "rails_helper"

describe 'as a logged in user' do
  it 'I can navigate to my cart from by order index' do
    user = FactoryBot.create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/"
    within "nav" do
      click_on "Orders"
    end
    within "nav" do
      click_on "Cart"
    end
    expect(current_path).to eq("/cart")
  end
end
