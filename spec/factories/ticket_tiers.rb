FactoryBot.define do
  factory :ticket_tier do

    sequence(:name) { |n| "Ticket Tier #{n}" }
    
    price     { Faker::Commerce.price(range: 10..100) }
    remaining { 100 }
    available { true }

    association :event
  end
end