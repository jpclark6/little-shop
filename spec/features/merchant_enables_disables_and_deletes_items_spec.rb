require "rails_helper"
describe 'as a merchant' do
  it 'I can disable items that are enabled' do
    merchant = FactoryBot.create(:merchant)
    item = FactoryBot.create(:item)
    merchant.items << item
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

    visit dashboard_items_path
    within "#item-#{item.id}" do
      click_on "Disable Item"
    end

    expect(current_path).to eq dashboard_items_path
    expect(page).to have_content("Item #{item.id} with name '#{item.name}' is now disabled.")

    within "#item-#{item.id}" do
      expect(page).to have_content("Status: Disabled")
    end
  end
  it 'I can enable items that are disabled' do
    merchant = FactoryBot.create(:merchant)
    item = FactoryBot.create(:item, enabled: false)
    merchant.items << item
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
    visit dashboard_items_path

    within "#item-#{item.id}" do
      click_on "Enable Item"
    end

    expect(current_path).to eq dashboard_items_path
    expect(page).to have_content("Item #{item.id} with name '#{item.name}' is now disabled.")

    within "#item-#{item.id}" do
      expect(page).to have_content("Status: Enabled")
    end
  end
end
