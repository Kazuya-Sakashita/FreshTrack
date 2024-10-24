FactoryBot.define do
  factory :product do
    name  { Faker::Food.ingredient }
    purchase_date { Faker::Date.between(from: 5.days.ago, to: Time.zone.today) }
    expiration_date { purchase_date ? (purchase_date + rand(3..30).days) : nil }
    notify_expiration { 1 }
    association :user
  end
end
