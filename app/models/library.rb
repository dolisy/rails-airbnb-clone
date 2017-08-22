class Library < ApplicationRecord
  belongs_to :user
  has_many :books

  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
