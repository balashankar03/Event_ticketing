FactoryBot.define do
    factory :event do
        name { Faker::Lorem.words(number: 3).join(' ').titleize } 
        description { Faker::Lorem.paragraph }
        datetime    { Faker::Time.forward(days: 30, period: :evening)}

        association :venue
        association :organizer, factory: [:organizer, :with_user]

        trait :past do
            datetime { Faker::Time.backward(days: 10) }
        end

        trait :sold_out do
            after(:create) do |event|
                create(:ticket_tier, event: event, remaining: 0, available: false)
            end
        end

        trait :with_categories do
            after(:create) do |event|
                create_list(:category, 2 ,events: [event])
            end
        end

    end
end