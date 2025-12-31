class Category < ApplicationRecord
    has_and_belongs_to_many :events

    def self.ransackable_attributes(auth_object = nil)
      ["id", "name", "created_at", "updated_at"]
    end

    def self.ransackable_associations(auth_object = nil)
      ["events"]
    end
end
