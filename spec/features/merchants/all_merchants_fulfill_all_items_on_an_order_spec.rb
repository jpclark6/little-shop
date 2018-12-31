require "rails_helper"

describe 'All merchants fullfill all items on an order' do
  it 'changes status from pending to complete' do
    user_1 = FactoryBot.create(:user)
    merchant_1 = FactoryBot.create(:merchant)
    merchant_2 = FactoryBot.create(:merchant)
    item_1 = FactoryBot.create(:item, user: merchant_1)
    item_2 = FactoryBot.create(:item, user: merchant_2)
    item_3 = FactoryBot.create(:item, user: merchant_2)

    order_1 = FactoryBot.create(:order, status: "pending", items: [item_1, item_2, item_3])
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_1)
    visit profile_order_path(order_1)
    within "#order-status" do
      expect(page).to have_content("Status: Pending")
    end

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1)
    visit dashboard_order_path(order_1)
    within "#item-#{item_1.id}" do
      click_on "Fulfill"
    end
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_1)
    visit profile_order_path(order_1)
    within "#order-status" do
      expect(page).to have_content("Status: Pending")
    end

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_2)
    visit dashboard_order_path(order_1)
    within "#item-#{item_2.id}" do
      click_on "Fulfill"
    end
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_1)
    visit profile_order_path(order_1)
    within "#order-status" do
      expect(page).to have_content("Status: Pending")
    end

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_2)
    visit dashboard_order_path(order_1)
    within "#item-#{item_3.id}" do
      click_on "Fulfill"
    end
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_1)
    visit profile_order_path(order_1)

    within "#order-status" do
      expect(page).to have_content("Status: Complete")
    end

  end

end
