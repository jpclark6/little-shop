FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Lisa#{n}"}
    sequence(:email) { |n| "Lisa#{n}@gmail.com" }
    address {"123 Happy St"}
    city { "Denver" }
    zip_code { 80015 }
    state { 'CO' }
    password { '2738^f' }
    role { 0 }
    enabled { true }
    factory :merchant do
      role { 1 }
    end
    factory :admin do
      role { 2 }
    end
    trait :disabled do
      enabled { false }
    end
  end

  factory :item do
    association :user, factory: :merchant
    sequence(:name) { |n| "Thing #{n}" }
    sequence(:instock_qty) { |n| 27 + n }
    sequence(:price) { |n| 44 + n }
    sequence(:image) { "/public/no_image_available.jpg" }
    sequence(:description) { |n| "this thing is....#{n}" }
    enabled { true }
  end
end
