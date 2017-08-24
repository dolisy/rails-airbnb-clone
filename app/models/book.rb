class Book < ApplicationRecord
  belongs_to :library

  has_many :bookings

  has_many :reviews, through: :bookings

  has_attachment :photo

  validates :title, presence: true
  validates :library, presence: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

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

  scope :sort_by, -> (sort_by) { order sort_by: sort_by }

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
        sum += review.stars
      end
    end
    if reviews_count == 0
      return average = 0
    else
      return average = sum.fdiv(reviews_count).round(1)
    end
  end
end
