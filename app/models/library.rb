class Library < ApplicationRecord
  belongs_to :user

  has_many :books

  has_many :bookings, through: :books
  has_many :reviews, through: :bookings

  validates :name, presence: true, uniqueness: { scope: :user, message: "A Library with this name has already been created"}
  validates :user, presence: true
end
