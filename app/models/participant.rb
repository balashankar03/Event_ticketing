class Participant < ApplicationRecord
    has_many :orders, dependent: :destroy
    has_many :tickets, through: :orders
    has_one :user, as: :userable, dependent: :destroy
    has_many :events, through: :orders

    def self.ransackable_attributes(auth_object = nil)
    ["id","date_of_birth","city","gender","created_at", "updated_at"]
    end

    def self.ransackable_associations(auth_object = nil)
    ["orders", "tickets", "user"]
    end

end
