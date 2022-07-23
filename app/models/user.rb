class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :voices, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true, presence: true
  validates :name, presence: true, length: { maximum: 30 }

  enum role: { general: 0, admin: 1, guest: 2 }
end
