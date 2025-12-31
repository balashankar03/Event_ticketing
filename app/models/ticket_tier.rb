class TicketTier < ApplicationRecord
  belongs_to :event
  has_many :tickets, dependent: :destroy

  before_create :set_default_availability

  before_save :update_availability_status

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "price", "remaining", "available", "event_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["event", "tickets"]
  end

private

  def update_availability_status
    if remaining.present? && remaining <= 0
      self.availability = false
    end
  end

  def set_default_availability
    self.available=true if self.available.nil?
  end
end
