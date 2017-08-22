class Library < ApplicationRecord
  belongs_to :user
  has_many :books
  has_many :reviews

  validates :name, presence: true, uniqueness: { scope: :user, message: "A Library with this name has already been created"}
  validates :user, presence: true


  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
