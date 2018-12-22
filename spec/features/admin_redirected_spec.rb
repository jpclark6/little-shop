require "rails_helper"
describe 'as an admin' do
  xit 'I am redirected from user show to merchant show if user is a merchant' do
    admin = FactoryBot.create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    merchant = FactoryBot.create(:merchant)

    visit "/admin/users/#{merchant.id}"


    expect(current_path).to eq(admin_merchant_path(merchant))

#     As an admin user
# If I visit a profile page for a user, but that user is a merchant
# Then I am redirected to the appropriate merchant dashboard page.
# eg, if I visit "/admin/users/7" but that user is a merchant
# Then I am redirected to "/admin/merchants/7"
# And I see their merchant dashboard page
  end
end
