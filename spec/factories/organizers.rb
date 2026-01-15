FactoryBot.define do
    factory :organizer do
        website  { "https://abc.com" }
        address  { "123 Tech Park" }
    
        trait :with_user do
            after(:create) { |org| create(:user, userable: org)}
        end
    end
end