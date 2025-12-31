class Ticket < ApplicationRecord
  belongs_to :order
  belongs_to :ticket_tier
  has_one :event, through: :ticket_tier

  before_validation :get_serial_no, on: [:create]
  
  validates :serial_no, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["id","order_id","ticket_tier_id", "serial_no", "seat_info", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["order", "ticket_tier", "event"]
  end

  private
  def get_serial_no
    return if serial_no.present?

    loop do
      self.serial_no = "TIC-#{SecureRandom.alphanumeric(8).upcase}"

      break unless Ticket.exists?(serial_no: serial_no)
    end
  end
      
end
