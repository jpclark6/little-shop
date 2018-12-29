# Database Schema:
![Alt text](./public/Database_1.png?raw=true "Title")


# Little Shop

We have built an online e-commerce platform to sell local artisan goods. Our site allows users to add items to a cart and check out to purchase them from merchants. Merchants may log in to purchase items, add items to their own inventories, enable and disable items, fulfill orders, and edit existing items available. Admin users have access to change user status from merchants to regular users and vice versa, disable and enable users and merchants, have access to additional analytics, and cancel orders.

## Getting Started

If you'd like to use this site, all you need to do it find a place you'd like to store it on your computer, and then clone it onto your computer.

```
git clone https://github.com/bendelonlee/little_shop.git
cd little_shop

```

### Prerequisites
You will need Rails installed and verify that it is version 5.1 and NOT 5.2

To check your version using terminal `run: rails -v` in the command line. If you have not installed rails, in terminal run: `gem install rails -v 5.1` in the command line.

### Installing

Open terminal in the `little_shop` directory and run these commands:
```
bundle
bundle update
rake db:{drop,create,migrate,seed}
rails s

```
Open a browser page (preferably in Chrome)

Navigate to `localhost:3000` and you should see our little app.

## Running the tests

Note: Before running RSpec, ensure you're in the project root directory (`little_shop`).

From terminal run: `rspec`

After RSpec has completed, you should see all tests passing as GREEN. Any tests that have failed or thrown an error will display RED. Any tests that have been skipped will be displayed as YELLOW.

### Feature tests

Feature tests are tests that check content in the page at a view level. We used Capybara for our assertions and FactoryBot to create test objects, here is an example:

```
describe 'user index page' do
  context 'as an admin' do

    it "shows all registered users" do
      user_1 = FactoryBot.create(:user)
      user_2 = FactoryBot.create(:user, enabled: false)
      merchant = FactoryBot.create(:merchant)
      admin = FactoryBot.create(:admin)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit root_path
      within ".nav-link-container" do
        click_on 'Users'
      end

      expect(current_path).to eq("/admin/users")
      within "#user-#{user_1.id}" do
        expect(page).to have_content(user_1.name)
        expect(page).to have_content("Registered at #{user_1.created_at.to_date}")
        expect(page).to have_button("Disable")
      end
      within "#user-#{user_2.id}" do
        expect(page).to have_content(user_2.name)
        expect(page).to have_content("Registered at #{user_2.created_at.to_date}")
        expect(page).to have_button("Enable")
      end

      expect(page).to_not have_css("#user-#{merchant.id}")
      expect(page).to_not have_css("#user-#{admin.id}")
    end
  end
end
```

### Model tests

We have 100% coverage on all model testing, we also include validation and relationship tests.
Here is an example of a model test:
```
RSpec.describe Order, type: :model do
  describe 'validations' do
    it {should validate_presence_of :status}
  end
  describe 'relationships' do
    it {should belong_to :user}
    it {should have_many :order_items}
  end

  describe 'instance methods' do
    it 'should add cart contents on to an order' do
      item_1 = FactoryBot.create(:item)
      item_2 = FactoryBot.create(:item)
      item_3 = FactoryBot.create(:item)
      cart = Cart.new({})
      cart.add_item(item_1.id.to_s)
      cart.add_item(item_2.id.to_s)
      cart.add_item(item_2.id.to_s)
      cart.add_item(item_3.id.to_s)
      user = FactoryBot.create(:user)
      order = Order.create(user: user, status: 'pending')
      order.add_cart(cart)
      expect(order.items).to eq([item_1, item_2, item_3])
    end

    it '.total_quantity' do
      item_1 = FactoryBot.create(:item)
      item_2 = FactoryBot.create(:item)
      item_3 = FactoryBot.create(:item)

      order = FactoryBot.create(:pending, items: [item_1,item_2,item_3])

      item_1.order_items.first.update(quantity: 1)
      item_2.order_items.first.update(quantity: 2)
      item_3.order_items.first.update(quantity: 3)

      expect(order.total_quantity).to eq(6)
    end
  end
end

```
# Schema:
https://dbdiagram.io/d/5c1539dc97b0960014c337df

# Rubric: https://github.com/turingschool-projects/little_shop_v2/blob/master/LittleShopRubric.pdf

# DTR: https://docs.google.com/document/d/1Yk3XVh2ThZJTLu6YO8zYsrDdLwssvQEewJIszPIGfcg/edit?usp=sharing

## Deployment

Our App is hosted on [Heroku](https://evening-eyrie-16856.herokuapp.com/)

## Built With

* Rails
* PostrgeSQL
* Bcrypt
* [Waffle.io](https://waffle.io)
* [GitHub](github.com)
* [FactoryBot](https://github.com/thoughtbot/factory_bot)
* RSpec
* Capybara
* Pry
* Launchy
* SimpleCov
* Shouldamatchers
* Chrome dev tools
* [Faker](https://github.com/stympy/faker)
* [Picsum Ipsum](https://picsumipsum.herokuapp.com/)

## Versioning

We use [GitHub](https://github.com/) for versioning.
We usee [Waffle.io](https://waffle.io/) as a project management tool.

## Authors

* **Justin Clark** - [jpclark6](https://github.com/jpclark6)
* **Mackenzie Frey** - [Mackenzie-Frey](https://github.com/Mackenzie-Frey)
* **Ben Lee** - [bendelonlee](https://github.com/bendelonlee)
* **Tom Nunez** - [tomjnunez](https://github.com/tomjnunez)
* **Maddie Jones** - [maddyg91](https://github.com/maddyg91)

## Acknowledgments

* **Ian Douglas** - [iandouglas](https://iandouglas.com/turing/)
* **Dione Wilson** - [dionew1](https://github.com/dionew1)
