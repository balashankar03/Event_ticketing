class User < ApplicationRecord
  belongs_to :userable, polymorphic: true
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :userable_type, inclusion: {in: %w(Organizer Participant)}

  before_save :downcase_email

  def downcase_email
    self.email=email.downcase
  end

end
