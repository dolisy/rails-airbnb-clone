class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :book

  has_many :reviews
  has_many :messages

  validates :book, presence: true
  validates :user, presence: true


end
