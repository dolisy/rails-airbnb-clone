class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :book, presence: true, uniqueness: { scope: [ :user, :pick_up_date, :return_date ] }
  validates :user, presence: true

end
