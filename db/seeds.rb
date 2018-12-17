# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "faker"
20.times do
  name = Faker::Name.name
  address = Faker::Address.street_address
  city = Faker::Address.city
  state = Faker::Address.state_abbr
  zip_code = Faker::Address.zip_code
  email = Faker::Internet.unique.email
  role = 0
  password = Faker::Name.name
  user = User.create(name: name, address: address, city: city, state: state, zip_code: zip_code, email: email, role: role, password: password, enabled: true)
end
10.times do
  name = Faker::Name.name
  address = Faker::Address.street_address
  city = Faker::Address.city
  state = Faker::Address.state_abbr
  zip_code = Faker::Address.zip_code
  email = Faker::Internet.unique.email
  role = 1
  password = Faker::Name.name
  user = User.create(name: name, address: address, city: city, state: state, zip_code: zip_code, email: email, role: role, password: password, enabled: true)
  10.times do
    name = Faker::Hipster.word
    instock_qty = rand(0..50)
    price = Faker::Commerce.price
    image = Faker::Internet.url
    description = Faker::Hipster.sentence
    user.items.create(name: name, instock_qty: instock_qty, price: price, image: image, description: description)
  end
end 
