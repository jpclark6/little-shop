require 'rails_helper'

describe 'As a user' do

end

describe 'when I visit and orders show page' do
  it 'should show the customers info and all of the order items' do

    visit_order_path(@order_1)

    expect(page).to have_content("Order #{@order_1.id}")
    expect(page).to have_content(@user_1.name)
    expect(page).to have_content(@user_1.address)
    expect(page).to have_content("#{@user.city}, #{@user.state} #{@user.zip}")
    expect(page).to have_content(@item_1.image)
  end
end
