class Venue < ApplicationRecord
    has_many :events, dependent: :destroy
    validates :name, :address, :city, presence: true

    def self.ransackable_attributes(auth_object = nil)
    ["name", "city", "address", "capacity", "created_at", "updated_at"]
    end

    def self.ransackable_associations(auth_object = nil)
    ["events"]
    end
    
end
