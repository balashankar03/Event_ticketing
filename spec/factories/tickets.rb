FactoryBot.define do
  factory :ticket do
    seat_info { "Row #{('A'..'Z').to_a.sample}-#{rand(1..50)}" }
    
    association :order
    association :ticket_tier
    
  end
end