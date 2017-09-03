class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :conversation

  has_many :reviews
  has_many :private_messages

  validates :book, presence: true
  validates :user, presence: true


end
