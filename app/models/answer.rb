class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  validates :growl_voice, presence: true
  validates :description, presence: true, length: { maximum: 30 }
end
