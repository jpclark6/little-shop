FactoryBot.define do
  factory :user do
    name {"Lisa"}
    sequence(:email) { |n| "Lisa#{n}@gmail.com" }
    address "123 Happy St"
    city "Denver"
    zip_code 80015
    state 'CO'
    password '2738^f'
    role 0
    enabled true
    factory :merchant do
      role 1
    end
    factory :admin do
      role 2
    end
  end

  factory :item do
    name 'Thing 1'
    instock_qty 27
    price 44
    image 'fgkfgkjd'
    description 'this thing is....'
    enabled true
  end
end
