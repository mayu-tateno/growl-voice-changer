class Topic < ApplicationRecord
  belongs_to :user

  validates :body, presence: true, length: { maximum: 100 }, uniqueness: true
end
