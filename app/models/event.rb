class Event < ApplicationRecord
  belongs_to :venue
  belongs_to :organizer
  has_many :ticket_tiers
  has_many :orders
  has_many :tickets, through: :ticket_tiers
  has_and_belongs_to_many :categories
end
