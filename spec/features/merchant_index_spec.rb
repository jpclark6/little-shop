require "rails_helper"

describe 'merchant index page' do
  context 'as a visitor' do
    it 'I see active merchants, their city, state and their registration date' do
      merchant_1 = FactoryBot.create(:merchant)
      merchant_2 = FactoryBot.create(:merchant)
      merchant_3 = FactoryBot.create(:merchant, :disabled)

      visit merchants_path

      within "#merchant-#{merchant_1.id}" do
        expect(page).to have_content(merchant_1.name)
        expect(page).to have_content(merchant_1.city)
        expect(page).to have_content(merchant_1.state)
        expect(page).to have_content(merchant_1.created_at.to_date)
      end
    end
  end
end
