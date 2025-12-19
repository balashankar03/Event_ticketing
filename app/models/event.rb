class Event < ApplicationRecord
  belongs_to :venue
  belongs_to :organizer
  has_many :ticket_tiers
  has_many :orders
  has_many :tickets, through: :ticket_tiers
  has_and_belongs_to_many :categories

  has_one_attached :image

  validates :name, presence: true, length: { minimum: 5 }
  validates :description, presence: true
  validates :datetime, presence: true
  validate :event_date_cannot_be_in_the_past

  validates :image, presence: true


  private
  def event_date_cannot_be_in_the_past
    if datetime.present? && datetime < Time.now
      errors.add(:datetime, "can't be in the past")
    end
  end
end
