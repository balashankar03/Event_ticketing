FactoryBot.define do
  factory :participant do
    
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
    city          { Faker::Address.city }
    gender        { ['Male', 'Female', 'Non-binary', 'Prefer not to say'].sample }

    trait :with_user do
      after(:create) do |participant|
        create(:user, userable: participant)
      end
    end
  end
end