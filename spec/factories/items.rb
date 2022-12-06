FactoryBot.define do
  factory :item do
    name { Faker::Restaurant.name }
    description { Faker::Restaurant.description}
    unit_price { Faker::Number.decimal(l_digits: 2) }
    merchant
  end
end
