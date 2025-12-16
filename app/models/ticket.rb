class Ticket < ApplicationRecord
  belongs_to :order
  belongs_to :ticket_tier
  has_one :event, through: :ticket_tier
end
