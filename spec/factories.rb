FactoryBot.define do
  factory :user do
    name {"Lisa"}
    sequence(:email) { |n| "Lisa#{n}@gmail.com" }
  end
end
