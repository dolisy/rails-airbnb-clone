class Review < ApplicationRecord
  belongs_to :library
  belongs_to :booking

  validates :user, presence: true, unless: ->(booking){booking.book.present?}
  validates :book, presence: true, unless: ->(booking){booking.user.present?}
end
