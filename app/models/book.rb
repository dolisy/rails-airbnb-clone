class Book < ApplicationRecord
  belongs_to :library
  has_many :bookings
end
