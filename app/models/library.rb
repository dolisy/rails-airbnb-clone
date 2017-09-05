class Library < ApplicationRecord
  belongs_to :user

  has_many :books
  accepts_nested_attributes_for :books

  has_many :bookings, through: :books
  has_many :reviews, through: :bookings


  # after_create :add_address_to_books
  after_save :add_address_to_books
  # after_update :add_address_to_books

  # after_touch :add_address_to_books


  validates :name, presence: true, uniqueness: { scope: :user, message: "A Library with this name has already been created"}
  validates :user, presence: true
  validates :address, presence: true

  # geocoded_by :address
  # after_validation :geocode, if: :address_changed?
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      begin
        obj.city    = geo.city
      rescue
      end
      begin
        obj.zipcode = geo.postal_code
      rescue
      end
      begin
        obj.country = geo.country_code
      rescue
      end
    end
  end
  after_validation :geocode, :reverse_geocode

  # for search

  scope :term, -> (term) { where("name ILIKE :search ", search: "%#{term}%") }

  scope :location, -> (location) { where("location like ?", "%#{location}%") }

  private

  def add_address_to_books
    unless self.books.empty?
      self.books.each do |book|
        book.update_attributes(address: address)
      end
    end
  end

end
