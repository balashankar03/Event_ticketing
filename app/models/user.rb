class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :userable, polymorphic: true, optional: true, dependent: :destroy
  accepts_nested_attributes_for :userable

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all 

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all


  validates :userable_type, inclusion: {in: %w(Organizer Participant)}

  has_one_attached :profile_picture

  before_save :downcase_email

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "email", "phone", "created_at", "updated_at", "userable_type", "userable_id"]
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

  def profile_picture_url
    if profile_picture.attached?
      profile_picture
    else
      "default-avatar.png"
    end
  end


  private

  def downcase_email
    self.email=email.downcase
  end

end
