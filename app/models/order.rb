class Order < ApplicationRecord
  belongs_to :event
  belongs_to :participant
  has_many :tickets, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ["id", "status", "event_id", "participant_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["event", "participant", "tickets"]
  end
end
