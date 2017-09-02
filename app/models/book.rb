class Book < ApplicationRecord
  belongs_to :library
  has_many :bookings
  has_many :reviews, through: :bookings

  # after_create :add_address_to_book
  # after_save :add_address_to_book

  has_attachment :photo

  validates :title, presence: true
  validates :library, presence: true

  # geocoded_by :address
  # after_validation :geocode
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

  scope :status, -> (status) { where status: status }

  # scope :title, -> (title) { where("title like ?", "%#{title}%") }
  # scope :author, -> (author) { where("author like ?", "%#{author}%") }
  # scope :publisher, -> (publisher) { where("publisher like ?", "%#{publisher}%") }
  # scope :genre, -> (genre) { where("genre like ?", "%#{genre}%") }
  # scope :isbn, -> (isbn) { where("isbn like ?", "%#{isbn}%") }
  # scope :description, -> (description) { where("description like ?", "%#{description}%") }

  scope :term, -> (term) { where("title ILIKE :search OR author ILIKE :search OR publisher ILIKE :search OR genre ILIKE :search OR isbn ILIKE :search OR description ILIKE :search", search: "%#{term}%") }

  scope :location, -> (location) { where("location like ?", "%#{location}%") }

  # for analytics
  def reviews_count
    count = 0

    self.bookings.each do |booking|
      count += booking.reviews.count
    end

    return count
  end

  def rating
    sum = 0

    self.bookings.each do |booking|
      booking.reviews.each do |review|
        sum += review.stars || 0
      end
    end
    if reviews_count == 0
      return average = 0
    else
      return average = sum.fdiv(reviews_count).round(1)
    end
  end

  # for search on book address
  # def add_address_to_book
  #   self.address = self.library.address
  #   p "callback called, address assigned #{self.address}"
  #   # self.longitude = self.library.longitude
  #   # self.latitude = self.library.latitude
  #   geocode if self.address_changed?

  # end
end
