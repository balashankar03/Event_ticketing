FactoryBot.define do
  factory :order do
    status { "completed" }
    association :event
    association :participant

    trait :with_tickets do
      after(:create) do |order|
        create_list(:ticket, 2, order: order)
      end
    end
  end
end