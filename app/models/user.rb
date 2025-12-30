class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :userable, polymorphic: true, optional: true
  accepts_nested_attributes_for :userable
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :userable_type, inclusion: {in: %w(Organizer Participant)}

  before_save :downcase_email

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "email", "created_at", "updated_at", "userable_type", "userable_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["userable"]
  end

  def organizer?
    userable_type == "Organizer"
  end

  def participant?
    userable_type == "Participant"
  end

  private

  def downcase_email
    self.email=email.downcase
  end

end
