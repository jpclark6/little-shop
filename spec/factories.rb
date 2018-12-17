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
  end
end
