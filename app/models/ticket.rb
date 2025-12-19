class Ticket < ApplicationRecord
  belongs_to :order
  belongs_to :ticket_tier
  has_one :event, through: :ticket_tier

  before_validation :get_serial_no, on: [:create]
  
  validates :serial_no, presence: true, uniqueness: true

  

  private
  def get_serial_no
    return if serial_no.present?

    loop do
      self.serial_no = "TIC-#{SecureRandom.alphanumeric(8).upcase}"

      break unless Ticket.exists?(serial_no: serial_no)
    end
  end
      
end
