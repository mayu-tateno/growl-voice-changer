class Voice < ApplicationRecord
  belongs_to :user

  validates :description, presence: true

  enum status: { open: 0, closed: 1 }
end
