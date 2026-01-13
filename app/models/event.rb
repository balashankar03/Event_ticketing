class Event < ApplicationRecord
  belongs_to :venue
  belongs_to :organizer
  has_many :ticket_tiers, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :tickets, through: :ticket_tiers
  has_and_belongs_to_many :categories
  has_many :participants, through: :orders

  has_one_attached :image
  

  validates :name, presence: true, length: { minimum: 5 }
  validates :description, presence: true
  validates :datetime, presence: true
  validate :event_date_cannot_be_in_the_past

  accepts_nested_attributes_for :ticket_tiers, allow_destroy: true, reject_if: :all_blank


  def self.search(query)
    if query.present?
      where("name ILIKE ?","%#{query}%")
    else
      all
    end
  end



  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "datetime", "created_at", "updated_at", "description", "organizer_id", "venue_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["categories", "image_attachment", "image_blob", "orders", "organizer", "ticket_tiers", "tickets", "venue"]
  end

  private
  def event_date_cannot_be_in_the_past
    if datetime.present? && datetime < Time.now
      errors.add(:datetime, "can't be in the past")
    end
  end
end
