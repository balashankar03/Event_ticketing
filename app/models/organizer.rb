class Organizer < ApplicationRecord
    has_many :events
    has_one :user, as: :userable
end
