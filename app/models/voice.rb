class Voice < ApplicationRecord
  belongs_to :user
  mount_uploader :growl_voice, GrowlVoiceUploader

  validates :growl_voice, presence: true
  validates :description, presence: true, length: { maximum: 30 }

  enum status: { open: 0, closed: 1 }
end
