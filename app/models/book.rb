class Book < ApplicationRecord
  belongs_to :library

  has_many :bookings

  has_many :reviews, through: :bookings

  has_attachment :photo

  validates :title, presence: true
  validates :library, presence: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  def self.search(term)
    wildcard_term = "%#{term}%"

    if wildcard_term
      where("title ILIKE :search OR author ILIKE :search OR publisher ILIKE :search OR genre ILIKE :search OR isbn ILIKE :search OR description ILIKE :search", search: wildcard_term).order('id DESC')
    else
      order('id DESC')
    end
  end
end

#Book.near(@address, @distance)
