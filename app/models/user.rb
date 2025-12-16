class User < ApplicationRecord
  belongs_to :userable, polymorphic: true
end
