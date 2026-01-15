FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    phone { Faker::PhoneNumber.cell_phone }
    password { 'password123' }

    association :userable, factory: :participant

    trait :for_participant do
      association :userable, factory: :participant
    end

    trait :for_organizer do
      association :userable, factory: :organizer
    end
  end


end