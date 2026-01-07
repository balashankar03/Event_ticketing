class Organizer < ApplicationRecord
    has_many :events, dependent: :destroy
    has_one :user, as: :userable, dependent: :destroy

    def self.ransackable_attributes(auth_object = nil)
    ["id","website", "address", "created_at", "updated_at"]
    end

    def self.ransackable_associations(auth_object = nil)
    ["events", "user"]
    end
end
