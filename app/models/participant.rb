class Participant < ApplicationRecord
    has_many :orders
    has_many :tickets, through: :orders
    has_one :user, as: :userable

end
