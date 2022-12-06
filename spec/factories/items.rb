FactoryBot.define do
  factory :item do
    name { Faker::Name.name }
    description { "MyString" }
    unit_price { "MyString" }
    merchant_id { "MyString" }
  end
end
