class Order < ApplicationRecord
  belongs_to :event
  belongs_to :participant
  has_many :tickets
end
