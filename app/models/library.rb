class Library < ApplicationRecord
  belongs_to :user

  has_many :books
  has_many :bookings, through: :books
  has_many :reviews, through: :bookings

  # after_create :add_address_to_books

  # after_save :add_address_to_books
  # after_update :add_address_to_books

  # after_touch :add_address_to_books


  validates :name, presence: true, uniqueness: { scope: :user, message: "A Library with this name has already been created"}
  validates :user, presence: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?


  private

  # def add_address_to_books
  #   unless self.books.empty?
  #     self.books.each do |book|
  #       book.address = self.address
  #       book.longitude = self.longitude
  #       book.latitude = self.latitude
  #     end
  #   end
  # end

end
