class Review < ApplicationRecord
  belongs_to :library
  belongs_to :booking
end
