class Review < ApplicationRecord
  belongs_to :library
  belongs_to :booking

  validates :library, presence: true, unless: ->(review){review.booking.present?}
  validates :booking, presence: true, unless: ->(review){review.library.present?}
end
